#!/bin/sh
# =============================================================================
# conformance.sh — capa barata de conformidad del harness (E13 / methodology §10)
# -----------------------------------------------------------------------------
# Verifica MECÁNICAMENTE lo que hasta ahora solo estaba escrito en los prompts de
# los agentes y que nadie ejecutaba. NO juzga calidad (§8): responde "¿se siguió
# el procedimiento?", no "¿el resultado es bueno?".
#
# Alcance (E4): lo comprobable con  artefactos + git log + _trace/trace.md .
# La sección D lee la TRAZA DE EJECUCIÓN (methodology.md §7.2) y con ella activa
# los checks del tipo "¿leyó antes de escribir?" (R2/R8, W0/W1, P1/P9), que
# antes estaban escritos en los prompts y nadie podía ejecutar.
# La traza es AUTODECLARADA: no es evidencia fuerte, es evidencia CONTRASTABLE
# (D3 la enfrenta a git log). La capa dura, por hooks, es posterior.
#
# Dependencias: git, grep, sed, awk. Nada más. Agnóstico al lenguaje del proyecto.
#
# Uso:   sh _tools/conformance.sh [ruta-del-proyecto]
#        (por defecto, el directorio actual)
#
# Salida: 0 = sin fallos · 1 = al menos un FALLO · 2 = error de invocación
#         Los AVISOS no alteran el código de salida: señalan algo que merece
#         mirada humana pero no viola el procedimiento.
# =============================================================================

set -u

ROOT="${1:-.}"

if [ ! -d "$ROOT" ]; then
  echo "conformance: '$ROOT' no es un directorio" >&2
  exit 2
fi

cd "$ROOT" || exit 2

# --- rutas canónicas (git-protocol.md §4) ------------------------------------
EXTRACT="_prototype/document_extract.md"
INTERVIEW="_prototype/interview_document.md"
DISCOVERY="_prototype/discovery.md"
PROTOTYPE="_prototype/prototype"
PROJECT_YAML="_context/project.yaml"
TRACE="_trace/trace.md"

MSG_EXTRACT="docs(prototipo): extracto del documento del cliente"
MSG_INTERVIEW="docs(prototipo): log de entrevista de descubrimiento"
MSG_DISCOVERY="docs(prototipo): entregable de descubrimiento"
MSG_PROTOTYPE="feat(prototipo): camino feliz del generador"

# --- contadores ---------------------------------------------------------------
N_PASS=0
N_FAIL=0
N_WARN=0
N_SKIP=0

pass() { N_PASS=$((N_PASS + 1)); printf '  ok    %-6s %s\n' "$1" "$2"; }
fail() { N_FAIL=$((N_FAIL + 1)); printf '  FALLO %-6s %s\n' "$1" "$2"; }
warn() { N_WARN=$((N_WARN + 1)); printf '  aviso %-6s %s\n' "$1" "$2"; }
skip() { N_SKIP=$((N_SKIP + 1)); printf '  --    %-6s %s\n' "$1" "$2"; }

section() { printf '\n%s\n' "$1"; }

# Los campos del discovery suelen ser prosa larga; en el reporte solo interesa
# reconocerlos, no leerlos enteros.
short() { printf '%s' "$1" | awk '{ if (length($0) > 60) print substr($0, 1, 60) "…"; else print }'; }

# Elimina comentarios HTML (incluidos los multilínea) para que los marcadores
# <...> de las guías de plantilla no se confundan con marcadores sin sustituir.
strip_comments() {
  awk '
    {
      line = $0
      out = ""
      while (1) {
        if (incomment) {
          p = index(line, "-->")
          if (p == 0) { line = ""; break }
          incomment = 0
          line = substr(line, p + 3)
        } else {
          p = index(line, "<!--")
          if (p == 0) { out = out line; break }
          out = out substr(line, 1, p - 1)
          incomment = 1
          line = substr(line, p + 4)
        }
      }
      print out
    }
  ' "$1"
}

# Valor de un campo "- **Etiqueta:** valor" de la sección Meta.
meta_field() {
  strip_comments "$2" | grep -m1 -i -- "- \*\*$1:\*\*" | sed "s/.*\*\*[^*]*:\*\*[[:space:]]*//" | sed 's/[[:space:]]*$//'
}

# ¿Existe un commit cuyo mensaje sea $1 y que toque la ruta $2?
# $3 = "borrador"  -> solo los marcados [sin confirmar]
# $3 = "limpio"    -> solo los NO marcados
# $3 = "cualquiera"
commits_matching() {
  _msg="$1"; _path="$2"; _kind="$3"
  git log --format='%s' -- "$_path" 2>/dev/null |
    grep -F -- "$_msg" |
    case "$_kind" in
      borrador) grep -F -- "[sin confirmar]" ;;
      limpio)   grep -v -F -- "[sin confirmar]" ;;
      *)        cat ;;
    esac
}

# =============================================================================
printf '=== Conformidad del harness — %s ===\n' "$(pwd)"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  printf '\nFALLO  el proyecto no es un repositorio git.\n'
  printf '       git-protocol.md §2 exige bootstrap antes del primer commit de\n'
  printf '       etapa. Sin repo, ninguna etapa tiene punto de retorno (L-009).\n'
  exit 1
fi

# =============================================================================
section "A · Artefactos"

# --- A1 · procedencia del nombre de proyecto (L-015, T-044) ------------------
if [ -f "$PROJECT_YAML" ]; then
  YAML_NAME=$(grep -m1 -E '^[[:space:]]*name:' "$PROJECT_YAML" |
    sed 's/.*name:[[:space:]]*//' | sed 's/^["'\'']//' | sed 's/["'\'']*[[:space:]]*$//')
else
  YAML_NAME=""
fi

for art in "$EXTRACT" "$INTERVIEW" "$DISCOVERY"; do
  [ -f "$art" ] || continue
  name=$(meta_field "Proyecto" "$art")
  base=$(basename "$art")
  if [ -z "$name" ]; then
    fail "A1" "$base: campo 'Proyecto' vacío o ausente"
  elif echo "$name" | grep -q '^<'; then
    fail "A1" "$base: 'Proyecto' sigue siendo un marcador sin sustituir ($name)"
  elif [ "$name" = "no declarado" ]; then
    pass "A1" "$base: 'no declarado' (procedencia honesta: project.yaml no lo trae)"
  elif [ -z "$YAML_NAME" ]; then
    warn "A1" "$base: nombre '$name' sin project.yaml que lo respalde"
  elif [ "$name" = "$YAML_NAME" ]; then
    pass "A1" "$base: nombre coincide con project.yaml"
  elif printf '%s' "$name" | grep -qF -- "$YAML_NAME"; then
    # El nombre de project.yaml está, acompañado de una anotación ("nombre de
    # trabajo, provisional…"). Eso es procedencia declarada, no fabricación
    # (T-044): lo que se caza aquí es un nombre INVENTADO, no uno matizado.
    pass "A1" "$base: nombre de project.yaml presente, con anotación"
  else
    fail "A1" "$base: 'Proyecto' = '$(short "$name")' no contiene el nombre de project.yaml ('$YAML_NAME')"
  fi
done

# --- A2 · marcadores sin sustituir -------------------------------------------
for art in "$EXTRACT" "$INTERVIEW" "$DISCOVERY"; do
  [ -f "$art" ] || continue
  base=$(basename "$art")
  left=$(strip_comments "$art" | grep -o '<[a-zA-Z0-9áéíóúñÁÉÍÓÚÑ][^<>]*>' | sort -u)
  if [ -n "$left" ]; then
    n=$(printf '%s\n' "$left" | wc -l | tr -d ' ')
    fail "A2" "$base: $n marcador(es) sin sustituir: $(printf '%s' "$left" | tr '\n' ' ')"
  else
    pass "A2" "$base: sin marcadores pendientes"
  fi
done

# --- A3/A4 · tabla de cobertura del extracto ---------------------------------
if [ -f "$EXTRACT" ]; then
  rows=$(strip_comments "$EXTRACT" | grep -E '^\|[[:space:]]*§[0-9]+[[:space:]]*\|')
  nrows=$(printf '%s\n' "$rows" | grep -c '§' || true)

  if [ "$nrows" -eq 10 ]; then
    pass "A3" "tabla de cobertura: las 10 áreas presentes"
  else
    fail "A3" "tabla de cobertura: $nrows áreas (se esperan 10)"
  fi

  # Nota: el bucle NO puede ir detrás de una tubería — correría en un subshell y
  # los contadores de fallos se perderían al salir de él.
  COV_TMP=$(mktemp)
  printf '%s\n' "$rows" > "$COV_TMP"

  while IFS= read -r row; do
    [ -n "$row" ] || continue
    area=$(printf '%s' "$row" | awk -F'|' '{print $2}' | sed 's/[[:space:]]//g')
    estado=$(printf '%s' "$row" | awk -F'|' '{print $4}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    falta=$(printf '%s' "$row" | awk -F'|' '{print $5}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    case "$estado" in
      cubierta|parcial|ausente|n/a) ;;
      *) fail "A4" "cobertura $area: estado no reconocido ('$estado')"; continue ;;
    esac

    # n/a y parcial exigen justificación en "Qué falta" — el n/a sin motivo es
    # una pregunta suprimida sin dejar rastro del hueco (check E6 del reader).
    if [ "$estado" = "n/a" ] || [ "$estado" = "parcial" ]; then
      if [ -z "$falta" ] || [ "$falta" = "—" ] || [ "$falta" = "-" ]; then
        fail "A5" "cobertura $area: estado '$estado' sin 'Qué falta' — el hueco queda sin rastro"
      fi
    fi

    # n/a solo se justifica por diseño: canónicamente §3 (lo deduce el
    # Descubridor) y §10 (split opcional). Fuera de ahí, mirada humana.
    if [ "$estado" = "n/a" ] && [ "$area" != "§3" ] && [ "$area" != "§10" ]; then
      warn "A6" "cobertura $area en 'n/a' fuera de las áreas de diseño (§3, §10): revisar que no sea un atajo"
    fi
  done < "$COV_TMP"
  rm -f "$COV_TMP"

  # --- A7 · coherencia estado/confirmación ----------------------------------
  est=$(meta_field "Estado" "$EXTRACT")
  conf=$(meta_field "Confirmado por el humano" "$EXTRACT")
  if [ "$est" = "cerrado" ] && [ "$conf" != "sí" ] && [ "$conf" != "si" ]; then
    fail "A7" "extracto: Estado='cerrado' pero 'Confirmado por el humano'='$conf'"
  else
    pass "A7" "extracto: estado y confirmación coherentes ($est / $conf)"
  fi
else
  skip "A3-A7" "no hay document_extract.md (flujo sin documento del cliente)"
fi

# --- A8 · Gatekeeper cuantitativo (W6) ---------------------------------------
if [ -f "$DISCOVERY" ]; then
  umbral=$(strip_comments "$DISCOVERY" | grep -m1 -i -- '- \*\*Umbral de éxito:\*\*' |
    sed 's/.*\*\*[^*]*:\*\*[[:space:]]*//')
  if [ -z "$umbral" ]; then
    # Un Gatekeeper con varias condiciones suele escribirse como encabezado +
    # lista numerada en las líneas siguientes (L-026/T-060), no en la misma
    # línea. Buscar el primer valor numérico ahí antes de declarar fallo.
    umbral=$(strip_comments "$DISCOVERY" | awk '
      /- \*\*Umbral de éxito:\*\*/ { found=1; next }
      found && /^[[:space:]]*$/ { exit }
      found && /^- \*\*/ { exit }
      found && /[0-9]/ { print; exit }
    ')
  fi
  if [ -z "$umbral" ]; then
    fail "A8" "discovery §7: falta 'Umbral de éxito'"
  elif printf '%s' "$umbral" | grep -q '[0-9]'; then
    pass "A8" "discovery §7: umbral cuantitativo ($(short "$umbral"))"
  else
    fail "A8" "discovery §7: umbral sin valor numérico ('$umbral') — un Gatekeeper no medible no es un gate"
  fi

  # --- A9 · timebox del prototipo -------------------------------------------
  tb=$(strip_comments "$DISCOVERY" | grep -m1 -i -- '- \*\*Duración tope del prototipo:\*\*' |
    sed 's/.*\*\*[^*]*:\*\*[[:space:]]*//')
  if [ -z "$tb" ]; then
    fail "A9" "discovery §8: falta 'Duración tope del prototipo' — cerrar por timebox contra un número que nadie fijó es medir contra nada"
  else
    pass "A9" "discovery §8: timebox declarado ($(short "$tb"))"
  fi
else
  skip "A8-A9" "no hay discovery.md todavía"
fi

# --- A10 · timebox de la entrevista acordado antes del bucle (I13) -----------
if [ -f "$INTERVIEW" ]; then
  itb=$(meta_field "Timebox acordado" "$INTERVIEW")
  motivo=$(meta_field "Motivo de cierre" "$INTERVIEW")
  if [ -z "$itb" ]; then
    fail "A10" "entrevista: 'Timebox acordado' vacío"
  elif [ "$itb" = "sin acordar" ] && printf '%s' "$motivo" | grep -qi 'timebox'; then
    fail "A10" "entrevista: cierra alegando 'timebox agotado' con el campo en 'sin acordar'"
  else
    pass "A10" "entrevista: timebox coherente con el motivo de cierre ($(short "$itb"))"
  fi
else
  skip "A10" "no hay interview_document.md todavía"
fi

# =============================================================================
section "B · Git (commit por etapa — git-protocol.md §3)"

check_stage_commit() {
  _label="$1"; _path="$2"; _msg="$3"

  if [ ! -e "$_path" ]; then
    skip "$_label" "$(basename "$_path"): la etapa no se ha ejecutado"
    return
  fi

  # B·a — el artefacto existe en disco pero nunca entró a git.
  # Es el fallo exacto de L-009/L-019: salida de etapa sin punto de retorno.
  if [ -n "$(git status --porcelain -- "$_path" 2>/dev/null)" ]; then
    fail "$_label" "$(basename "$_path"): hay cambios SIN CONFIRMAR — salida de etapa sin punto de retorno (L-009)"
  fi

  n_any=$(commits_matching "$_msg" "$_path" cualquiera | wc -l | tr -d ' ')
  if [ "$n_any" -eq 0 ]; then
    fail "$_label" "$(basename "$_path"): ningún commit de etapa con el mensaje canónico"
    if git log --format='%s' -- "$_path" 2>/dev/null | grep -q .; then
      printf '        (el path sí tiene commits, pero con otro mensaje: revisar §4 de git-protocol.md)\n'
    fi
  else
    pass "$_label" "$(basename "$_path"): $n_any commit(s) de etapa"
  fi
}

# --- B0 · la rama coincide con la declarada en project.yaml -------------------
# `git init` a secas toma init.defaultBranch de la MÁQUINA, así que el harness
# produciría `master` en un equipo y `main` en otro, y el push del cierre
# publicaría la rama actual en un repo que declara otra (git-protocol.md §2).
if [ -f "$PROJECT_YAML" ]; then
  DECL_BRANCH=$(grep -m1 -E '^[[:space:]]*default_branch:' "$PROJECT_YAML" |
    sed 's/.*default_branch:[[:space:]]*//' | sed 's/^["'\'']//' | sed 's/["'\'']*[[:space:]]*$//')
  CUR_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  if [ -z "$DECL_BRANCH" ]; then
    warn "B0" "project.yaml no declara 'repository.default_branch'"
  elif [ "$CUR_BRANCH" = "HEAD" ]; then
    warn "B0" "HEAD desacoplado; no se puede comparar con '$DECL_BRANCH'"
  elif [ "$CUR_BRANCH" = "$DECL_BRANCH" ]; then
    pass "B0" "rama '$CUR_BRANCH' coincide con project.yaml"
  else
    fail "B0" "rama actual '$CUR_BRANCH' ≠ 'repository.default_branch' ('$DECL_BRANCH') — el repo se inicializó sin leer project.yaml, o se trabaja fuera de la rama declarada"
  fi
else
  skip "B0" "no hay _context/project.yaml"
fi

check_stage_commit "B1" "$EXTRACT"   "$MSG_EXTRACT"
check_stage_commit "B2" "$INTERVIEW" "$MSG_INTERVIEW"
check_stage_commit "B3" "$DISCOVERY" "$MSG_DISCOVERY"
check_stage_commit "B4" "$PROTOTYPE" "$MSG_PROTOTYPE"

# --- B5 · doble escritura de la confirmación ---------------------------------
# El artefacto nace en borrador y se confirma con [sin confirmar]; si el humano
# aprueba después, esa aprobación produce SU PROPIO commit sin el marcador.
# Un artefacto cerrado con un solo commit limpio significa que la confirmación
# se adelantó: nadie puede distinguir el estado revisado del que nadie miró.
check_double_write() {
  _label="$1"; _path="$2"; _msg="$3"; _estado="$4"

  [ -f "$_path" ] || return
  if [ "$_estado" != "cerrado" ]; then
    skip "$_label" "$(basename "$_path"): en borrador, la doble escritura aún no aplica"
    return
  fi

  n_draft=$(commits_matching "$_msg" "$_path" borrador | wc -l | tr -d ' ')
  n_clean=$(commits_matching "$_msg" "$_path" limpio  | wc -l | tr -d ' ')

  if [ "$n_clean" -eq 0 ]; then
    fail "$_label" "$(basename "$_path"): cerrado pero sin commit de aprobación (todos llevan [sin confirmar])"
  elif [ "$n_draft" -eq 0 ]; then
    fail "$_label" "$(basename "$_path"): cerrado con un único commit limpio — la confirmación se adelantó al gate"
  else
    pass "$_label" "$(basename "$_path"): doble escritura correcta ($n_draft borrador + $n_clean aprobación)"
  fi
}

if [ -f "$EXTRACT" ]; then
  check_double_write "B5" "$EXTRACT" "$MSG_EXTRACT" "$(meta_field "Estado" "$EXTRACT")"
fi
if [ -f "$DISCOVERY" ]; then
  check_double_write "B6" "$DISCOVERY" "$MSG_DISCOVERY" "$(meta_field "Estado" "$DISCOVERY")"
fi

# --- B7 · el prototipo precede al gate ---------------------------------------
# Ya verificable: lo cubre D4 (sección D), que lee la traza de ejecución.

# =============================================================================
section "C · Definiciones (lint agente↔skill)"

# --- C1 · capacidad de commit (L-017) ----------------------------------------
# Si el skill de un agente le exige confirmar en git, ese agente necesita Bash.
# Este es EXACTAMENTE el fallo que dejó a L-009 sin evaluar en tres etapas: la
# regla estaba escrita y el agente no podía cumplirla.
if [ -d ".claude/agents" ]; then
  for agent in .claude/agents/*.md; do
    [ -f "$agent" ] || continue
    aname=$(basename "$agent" .md)
    atools=$(grep -m1 '^tools:' "$agent" || true)

    # Solo cuentan los skills que el agente INVOCA, no los que menciona de
    # pasada: la convención es "Invoca el skill **`nombre`**". Un match por
    # simple mención señalaría a un agente por un skill que nunca ejecuta.
    invoked=$(grep -oE 'nvoca el skill \*\*`[a-z0-9-]+`\*\*' "$agent" 2>/dev/null |
      grep -oE '`[a-z0-9-]+`' | tr -d '`' | sort -u)

    if [ -z "$invoked" ]; then
      warn "C1" "$aname: no declara invocación de skill reconocible — el lint no puede comprobar sus capacidades"
      continue
    fi

    needs_bash=""
    for sname in $invoked; do
      [ -f ".claude/skills/$sname/SKILL.md" ] || continue
      if grep -qiE 'git (add|commit)|commit de etapa|git-protocol' ".claude/skills/$sname/SKILL.md" 2>/dev/null; then
        needs_bash="$needs_bash $sname"
      fi
    done

    if [ -n "$needs_bash" ]; then
      if printf '%s' "$atools" | grep -q 'Bash'; then
        pass "C1" "$aname: declara Bash y sus skills lo exigen ($(printf '%s' "$needs_bash" | sed 's/^ //'))"
      else
        fail "C1" "$aname: invoca skill(s) que exigen commit ($(printf '%s' "$needs_bash" | sed 's/^ //')) pero NO declara Bash (L-017)"
      fi
    fi
  done
else
  skip "C1" "no hay .claude/agents/ en este proyecto"
fi

# --- C2 · los skills referenciados existen -----------------------------------
if [ -d ".claude/agents" ] && [ -d ".claude/skills" ]; then
  for agent in .claude/agents/*.md; do
    [ -f "$agent" ] || continue
    aname=$(basename "$agent" .md)
    refs=$(grep -oE '`[a-z][a-z0-9-]*-protocol`' "$agent" 2>/dev/null | tr -d '`' | sort -u)
    for r in $refs; do
      if [ ! -f ".claude/skills/$r/SKILL.md" ]; then
        fail "C2" "$aname: referencia el skill '$r', que no existe"
      fi
    done
  done
  pass "C2" "referencias a skills resueltas"
fi

# =============================================================================
section "D · Traza de ejecución (methodology.md §7.2)"

# La traza es AUTODECLARADA: la escribe el propio agente sobre sí mismo, así que
# NO es evidencia fuerte (§10: el auto-reporte es narrativa). Su valor es ser
# CONTRASTABLE — D3 la enfrenta a `git log`, que el agente no controla. Una
# contradicción entre ambos ES el hallazgo, sin importar cuál de los dos falle.
#
# Estos checks activan lo que hasta ahora estaba escrito en los prompts y era
# imposible de ejecutar: R2/R8 (reader), W0/W1 (writer), P1/P9 (prototipador).

if [ ! -f "$TRACE" ]; then
  skip "D1-D8" "no hay $TRACE (proyecto anterior a la traza, o ninguna etapa ejecutada)"
else
  # Filas de datos: '| 001 | agente | modelo | evento | objetivo | detalle | ts |'
  ROWS_TMP=$(mktemp)
  grep -E '^\|[[:space:]]*[0-9]{3}[[:space:]]*\|' "$TRACE" > "$ROWS_TMP" 2>/dev/null || true
  NROWS=$(grep -c . "$ROWS_TMP" 2>/dev/null || echo 0)

  # Nº de secuencia de la primera fila que cumple: agente=$1, evento=$2, objetivo~$3.
  # Vacío si no hay ninguna. ($3 vacío = cualquier objetivo.)
  seq_of() {
    awk -F'|' -v ag="$1" -v ev="$2" -v ob="$3" '
      { for (i = 2; i <= 8; i++) gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i) }
      $3 == ag && $5 == ev && (ob == "" || index($6, ob) > 0) { print $2; exit }
    ' "$ROWS_TMP"
  }
  # Igual, pero la ÚLTIMA coincidencia.
  seq_last() {
    awk -F'|' -v ag="$1" -v ev="$2" -v ob="$3" '
      { for (i = 2; i <= 8; i++) gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i) }
      $3 == ag && $5 == ev && (ob == "" || index($6, ob) > 0) { last = $2 }
      END { if (last != "") print last }
    ' "$ROWS_TMP"
  }
  count_rows() {
    awk -F'|' -v ag="$1" -v ev="$2" '
      { for (i = 2; i <= 8; i++) gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i) }
      $3 == ag && (ev == "" || $5 == ev) { n++ }
      END { print n + 0 }
    ' "$ROWS_TMP"
  }
  # Agentes distintos que aparecen en la traza.
  AGENTS_SEEN=$(awk -F'|' '{ gsub(/^[[:space:]]+|[[:space:]]+$/, "", $3); if ($3 != "") print $3 }' \
    "$ROWS_TMP" | sort -u)

  if [ "$NROWS" -eq 0 ]; then
    fail "D1" "la traza existe pero no tiene ninguna fila de evento"
  else

  # --- D1 · traza bien formada ------------------------------------------------
  # Sin secuencia legible el archivo pierde su única función: el ORDEN.
  D1_BAD=$(awk -F'|' 'NF != 9 { print NR }' "$ROWS_TMP" | wc -l | tr -d ' ')
  D1_DUP=$(awk -F'|' '{ gsub(/[[:space:]]/, "", $2); print $2 }' "$ROWS_TMP" | sort | uniq -d)
  D1_GAP=$(awk -F'|' '{ gsub(/[[:space:]]/, "", $2); if ($2 + 0 != ++n) { print n; exit } }' "$ROWS_TMP")

  if [ "$D1_BAD" -ne 0 ]; then
    fail "D1" "$D1_BAD fila(s) con número de columnas incorrecto (se esperan 7)"
  elif [ -n "$D1_DUP" ]; then
    fail "D1" "secuencia duplicada ($(printf '%s' "$D1_DUP" | tr '\n' ' ')) — el orden deja de ser legible"
  elif [ -n "$D1_GAP" ]; then
    fail "D1" "secuencia no correlativa: se esperaba $D1_GAP y no está — ¿se reescribió o se borró una fila?"
  else
    pass "D1" "traza bien formada: $NROWS evento(s), secuencia correlativa"
  fi

  # --- D2 · leer antes de escribir (R2 · W0 · W1 · P1) ------------------------
  # El check que la traza vino a habilitar. Hasta ahora "¿leyó el extracto antes
  # de escribir el discovery?" solo podía responderlo un humano mirando.
  # Formato: agente : insumo : artefacto propio : etiqueta del check original
  D2_SPEC=$(mktemp)
  cat > "$D2_SPEC" <<'EOF'
onboarding-reader:client_brief:document_extract.md:§5.1
onboarding-writer:interview_document.md:discovery.md:W1
onboarding-writer:document_extract.md:discovery.md:W0
prototype-builder:discovery.md:prototype:P1
EOF
  while IFS=: read -r ag insumo art orig; do
    [ -n "$ag" ] || continue
    s_write=$(seq_of "$ag" write "$art")
    [ -n "$s_write" ] || continue          # esa etapa no llegó a escribir: nada que ordenar
    s_read=$(seq_of "$ag" read "$insumo")
    if [ -z "$s_read" ]; then
      fail "D2" "$ag escribió $art sin ninguna lectura de $insumo en la traza ($orig)"
    elif [ "$s_read" -lt "$s_write" ]; then
      pass "D2" "$ag: leyó $insumo (#$s_read) antes de escribir $art (#$s_write) — $orig"
    else
      fail "D2" "$ag: leyó $insumo en #$s_read, DESPUÉS de escribir $art en #$s_write ($orig)"
    fi
  done < "$D2_SPEC"
  rm -f "$D2_SPEC"

  # --- D2b · confirmación previa a la ingesta (R2) ----------------------------
  # NC-6: nada de ingerir en silencio un archivo equivocado. El humano elige el
  # brief ANTES de que se lea, no después.
  r_read=$(seq_of onboarding-reader read client_brief)
  if [ -z "$r_read" ]; then
    skip "D2b" "el reader no leyó ningún brief en esta traza"
  else
    r_conf=$(seq_of onboarding-reader confirm "")
    if [ -z "$r_conf" ]; then
      fail "D2b" "el reader leyó el brief (#$r_read) sin ninguna confirmación humana previa (R2/NC-6)"
    elif [ "$r_conf" -lt "$r_read" ]; then
      pass "D2b" "reader: el humano confirmó el brief (#$r_conf) antes de leerlo (#$r_read) — R2"
    else
      fail "D2b" "reader: leyó el brief en #$r_read y el humano lo confirmó en #$r_conf — ingesta en silencio (R2)"
    fi
  fi

  # --- D2c · la confirmación no se adelantó (R8/L-007/L-023) ------------------
  # El artefacto nace en borrador y pasa a cerrado en una escritura POSTERIOR a
  # que el humano confirme. Un único `write` significa que nadie pudo distinguir
  # el estado revisado del que nadie miró.
  for pair in "onboarding-reader|document_extract.md|R8" "onboarding-writer|discovery.md|L-023"; do
    _ag=${pair%%|*}; _rest=${pair#*|}; _art=${_rest%%|*}; _orig=${_rest#*|}
    n_w=$(awk -F'|' -v ag="$_ag" -v art="$_art" '
      { for (i = 2; i <= 8; i++) gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i) }
      $3 == ag && $5 == "write" && index($6, art) > 0 { n++ } END { print n + 0 }' "$ROWS_TMP")
    [ "$n_w" -gt 0 ] || continue
    # La ÚLTIMA confirmación, no la primera: en el reader la primera es la del
    # archivo a ingerir (R2), y comparar el cierre contra ella daría un ok por
    # la razón equivocada. La que cierra el artefacto es la de cobertura/gate.
    _conf=$(seq_last "$_ag" confirm "")
    _last_w=$(seq_last "$_ag" write "$_art")
    if [ -z "$_conf" ]; then
      warn "D2c" "$_ag: escribió $_art pero la traza no registra confirmación humana ($_orig)"
    elif [ "$_last_w" -gt "$_conf" ]; then
      pass "D2c" "$_ag: la escritura de cierre (#$_last_w) es posterior a la confirmación (#$_conf) — $_orig"
    else
      fail "D2c" "$_ag: su última escritura de $_art (#$_last_w) precede a la confirmación (#$_conf) — el cierre se adelantó al gate ($_orig)"
    fi
  done

  # --- D3 · la traza contra git log (el contraste duro) -----------------------
  # Único check que enfrenta lo autodeclarado con evidencia que el agente no
  # controla. Si discrepan, algo falló — da igual cuál de los dos mienta.
  D3_TMP=$(mktemp)
  awk -F'|' '
    { for (i = 2; i <= 8; i++) gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i) }
    $5 == "commit" { print $2 "\t" $6 }
  ' "$ROWS_TMP" > "$D3_TMP"
  N_CROWS=$(grep -c . "$D3_TMP" 2>/dev/null || echo 0)

  D3_ORPHAN=0
  while IFS="$(printf '\t')" read -r cseq chash; do
    [ -n "$chash" ] || continue
    if ! git rev-parse --verify --quiet "${chash}^{commit}" >/dev/null 2>&1; then
      fail "D3" "fila #$cseq declara el commit '$chash', que NO existe en el repo"
      D3_ORPHAN=$((D3_ORPHAN + 1))
    fi
  done < "$D3_TMP"
  rm -f "$D3_TMP"

  if [ "$N_CROWS" -eq 0 ]; then
    warn "D3" "la traza no declara ningún commit"
  elif [ "$D3_ORPHAN" -eq 0 ]; then
    pass "D3" "los $N_CROWS commit(s) declarados existen en git"
  fi

  # Inversa: un commit de etapa en git que la traza no menciona significa que el
  # agente commiteó sin dejar rastro, o que otro lo hizo por él (L-017).
  # El bucle NO puede colgar de una tubería: correría en un subshell y los
  # contadores de warn/fail se perderían al salir de él.
  D3_INV=$(mktemp)
  for pair in "$EXTRACT|$MSG_EXTRACT" "$INTERVIEW|$MSG_INTERVIEW" \
              "$DISCOVERY|$MSG_DISCOVERY" "$PROTOTYPE|$MSG_PROTOTYPE"; do
    _p=${pair%%|*}; _m=${pair#*|}
    [ -e "$_p" ] || continue
    git log --format='%h %s' -- "$_p" 2>/dev/null | grep -F -- "$_m" >> "$D3_INV" || true
  done
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    h=${line%% *}
    grep -qF -- "$h" "$TRACE" || \
      warn "D3" "commit de etapa $h ($(short "${line#* }")) no aparece en la traza — ¿commiteó otro por él? (L-017)"
  done < "$D3_INV"
  rm -f "$D3_INV"

  # --- D4 · el commit de etapa precede al gate (B7 · P9 · L-019) --------------
  # Tercera reaparición de L-009: colgar el commit del gate deja el prototipo
  # fuera de git si el gate se salta o se difiere.
  for ag in onboarding-writer prototype-builder; do
    s_gate=$(seq_last "$ag" ask humano)
    s_commit=$(seq_of "$ag" commit "")
    if [ -z "$s_gate" ]; then
      skip "D4" "$ag: no cedió gate en esta traza"
    elif [ -z "$s_commit" ]; then
      fail "D4" "$ag: pidió el gate (#$s_gate) sin ningún commit previo en la traza (L-009/L-019)"
    elif [ "$s_commit" -lt "$s_gate" ]; then
      pass "D4" "$ag: commit (#$s_commit) antes del gate (#$s_gate)"
    else
      fail "D4" "$ag: el commit (#$s_commit) es POSTERIOR al gate (#$s_gate) — el commit colgó del gate (L-019)"
    fi
  done

  # --- D5 · checkpoints intra-etapa del bucle (L-025) -------------------------
  # git-protocol.md §3.1 exige confirmar cada iteración que deja algo que corre.
  P_WRITES=$(count_rows prototype-builder write)
  P_COMMITS=$(count_rows prototype-builder commit)
  if [ "$P_WRITES" -eq 0 ]; then
    skip "D5" "el prototipador no construyó en esta traza"
  elif [ "$P_COMMITS" -gt 1 ]; then
    pass "D5" "prototipo: $P_COMMITS commits para $P_WRITES escritura(s) — hubo checkpoints"
  elif [ "$P_WRITES" -gt 1 ]; then
    fail "D5" "prototipo: $P_WRITES escrituras y $P_COMMITS commit — el bucle corrió sin checkpoints intra-etapa (L-025)"
  else
    pass "D5" "prototipo: una escritura, un commit"
  fi

  # --- D6 · toda invocación cierra --------------------------------------------
  # Un `start` sin `end` es un agente que murió o que se olvidó de cerrar: en
  # ambos casos, lo que sigue en la traza no es interpretable.
  for ag in $AGENTS_SEEN; do
    n_start=$(count_rows "$ag" start)
    n_end=$(count_rows "$ag" end)
    if [ "$n_start" -eq "$n_end" ] && [ "$n_start" -gt 0 ]; then
      pass "D6" "$ag: $n_start invocación(es), todas cerradas"
    elif [ "$n_start" -eq 0 ]; then
      fail "D6" "$ag: tiene eventos pero ningún 'start' — la invocación no se delimitó"
    else
      fail "D6" "$ag: $n_start 'start' y $n_end 'end' — invocación sin cerrar"
    fi
  done

  # --- D7 · ninguna confirmación sin pregunta previa (L-007/L-016) ------------
  # L-007 fue escribir "confirmado: sí" antes de preguntar. Aquí se ve directo:
  # un `confirm` sin `ask` pendiente del mismo agente es una confirmación
  # adelantada, o inventada.
  D7_BAD=$(awk -F'|' '
    { for (i = 2; i <= 8; i++) gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i) }
    $5 == "ask"     { pend[$3]++ }
    $5 == "confirm" { if (pend[$3] > 0) pend[$3]--; else print $2 }
  ' "$ROWS_TMP")
  if [ -n "$D7_BAD" ]; then
    fail "D7" "confirmación sin pregunta previa en la(s) fila(s): $(printf '%s' "$D7_BAD" | tr '\n' ' ')"
  else
    pass "D7" "toda confirmación tiene su pregunta previa"
  fi

  # --- D8 · el modelo declarado es el real (D-039/T-072) ----------------------
  # Sin esto, atribuir el resultado de una corrida a un modelo es indemostrable
  # y el experimento controlado de T-072 no es falsable.
  if [ -d ".claude/agents" ]; then
    for ag in $AGENTS_SEEN; do
      adef=".claude/agents/$ag.md"
      [ -f "$adef" ] || { warn "D8" "$ag: aparece en la traza pero no existe $adef"; continue; }
      declared=$(grep -m1 '^model:' "$adef" | sed 's/^model:[[:space:]]*//' | tr -d '\r')
      intrace=$(awk -F'|' -v ag="$ag" '
        { for (i = 2; i <= 8; i++) gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i) }
        $3 == ag { print $4 }
      ' "$ROWS_TMP" | sort -u)
      n_models=$(printf '%s\n' "$intrace" | grep -c .)
      if [ -z "$declared" ]; then
        warn "D8" "$ag: su definición no declara 'model:'"
      elif [ "$n_models" -gt 1 ]; then
        warn "D8" "$ag: la traza mezcla modelos ($(printf '%s' "$intrace" | tr '\n' ' ')) — ¿corridas de distintas sesiones?"
      elif [ "$intrace" = "$declared" ]; then
        pass "D8" "$ag: modelo de la traza coincide con su definición ($declared)"
      else
        fail "D8" "$ag: la traza dice '$intrace' y su definición declara '$declared'"
      fi
    done
  else
    skip "D8" "no hay .claude/agents/ para contrastar el modelo"
  fi

  fi  # NROWS > 0
  rm -f "$ROWS_TMP"
fi

# =============================================================================
printf '\n=== Resumen: %s ok · %s fallo(s) · %s aviso(s) · %s omitido(s) ===\n' \
  "$N_PASS" "$N_FAIL" "$N_WARN" "$N_SKIP"

if [ "$N_FAIL" -gt 0 ]; then
  printf 'Veredicto: NO CONFORME\n'
  exit 1
fi

printf 'Veredicto: CONFORME (artefactos + git log + traza autodeclarada)\n'
exit 0
