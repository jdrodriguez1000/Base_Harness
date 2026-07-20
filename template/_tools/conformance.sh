#!/bin/sh
# =============================================================================
# conformance.sh — capa barata de conformidad del harness (E13 / methodology §10)
# -----------------------------------------------------------------------------
# Verifica MECÁNICAMENTE lo que hasta ahora solo estaba escrito en los prompts de
# los agentes y que nadie ejecutaba. NO juzga calidad (§8): responde "¿se siguió
# el procedimiento?", no "¿el resultado es bueno?".
#
# Alcance deliberado (E4): solo lo comprobable con  artefactos + git log .
# Los checks del tipo "¿leyó antes de escribir?" necesitan traza de ejecución y
# quedan fuera — son del motor de traza (T-039).
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
# No verificable sin traza: queda anotado para T-039.

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
printf '\n=== Resumen: %s ok · %s fallo(s) · %s aviso(s) · %s omitido(s) ===\n' \
  "$N_PASS" "$N_FAIL" "$N_WARN" "$N_SKIP"

if [ "$N_FAIL" -gt 0 ]; then
  printf 'Veredicto: NO CONFORME\n'
  exit 1
fi

printf 'Veredicto: CONFORME (a lo comprobable sin traza de ejecución)\n'
exit 0
