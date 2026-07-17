---
name: register-harness
description: >-
  Audita y (opcionalmente) provisiona la portabilidad del harness a otra herramienta de agente
  (Codex, opencode, Gemini). Revisa qué hace falta para que los agentes y skills de sesión
  (inicio/cierre) puedan usarse en la herramienta destino, comparando la fuente de verdad
  (`.claude/`) con las ubicaciones y formatos que esa herramienta espera, e informa qué falta.
  Si el usuario lo confirma, PROVISIONA: crea los skills y agentes nativos que faltan. Úsalo cuando
  el usuario diga "registrar harness", "register harness", "¿qué falta para usar el harness en
  opencode/codex/gemini?", "provisiona opencode" o vaya a cambiar de herramienta. Herramientas
  soportadas por ahora: opencode y Gemini.
---

# register-harness — Portabilidad del harness (auditar + provisionar)

Objetivo: lograr que los agentes y skills de sesión del harness (`startup-protocol` /
`closing-protocol` y sus agentes `sesion-starter` / `sesion-closer`) se puedan usar en otra
herramienta de agente. El skill tiene **dos modos**:

- **AUDITAR** (por defecto, solo lectura): dice **qué falta** en el destino.
- **PROVISIONAR** (solo con confirmación del usuario): **crea** los elementos nativos que faltan a
  partir de la fuente de verdad.

## Principio: fuente única de verdad

La base principal del harness es **Claude Code**. Por tanto, la fuente canónica es:

- Skills: `.claude/skills/startup-protocol/SKILL.md`, `.claude/skills/closing-protocol/SKILL.md`
- Agentes: `.claude/agents/sesion-starter.md`, `.claude/agents/sesion-closer.md`
- Instrucciones agnósticas: `AGENTS.md` (con ambos protocolos en línea)

Todo lo demás se considera un **reflejo generado** desde esta fuente. El destino es siempre un
reflejo, nunca al revés: nunca se edita el destino a mano ni se propaga del destino a la fuente.

---

## Paso 0 — Preparación

> **Ejecutable desde cualquier herramienta.** Este procedimiento no es exclusivo de Claude Code: su
> fuente son archivos de texto (`.claude/…` + `AGENTS.md`) que se leen con las tools de archivo de
> cualquier agente. Su versión resumida está espejada en `AGENTS.md` (sección *Portabilidad del
> harness*), de modo que un agente en opencode/Codex/Gemini pueda auditar y provisionar aunque aún no
> exista el skill nativo. Mantener ambos (este skill y esa sección de `AGENTS.md`) alineados.

1. Ubicarse en la raíz del proyecto.
2. **Verificar la fuente de verdad.** Comprobar que existen los 4 archivos canónicos y `AGENTS.md`.
   Si falta alguno de la fuente, reportarlo primero: sin fuente no hay nada que portar. **No** se
   puede provisionar si la fuente está incompleta.
3. **Determinar la herramienta destino.** Si el usuario no la indicó, preguntar. Soportadas por
   ahora: **opencode** (Paso 1–3) y **Gemini** (Paso 4). (Codex queda para próximas iteraciones.)
4. **Determinar el modo.** Por defecto, AUDITAR. Solo pasar a PROVISIONAR si el usuario lo pide
   explícitamente ("provisiona", "créalos", "hazlo") o lo confirma tras ver el reporte de auditoría.

---

## Paso 1 — Auditar destino: opencode

opencode busca sus componentes en estas ubicaciones (verificado en su documentación):

| Componente | Ubicación en opencode | ¿Contenido reutilizable desde la fuente? |
|---|---|---|
| Instrucciones | `AGENTS.md` (raíz del proyecto) | Sí — mismo archivo agnóstico |
| Skills | `.opencode/skills/<nombre>/SKILL.md` | **Sí** — mismo formato `SKILL.md`; se copia el contenido |
| Agentes | `.opencode/agents/<nombre>.md` | Parcial — requiere **traducir el frontmatter** |

Revisar (solo lectura) la presencia de cada elemento y anotar ✅ presente / ❌ falta:

### 1.1 Baseline universal
- [ ] `AGENTS.md` existe en la raíz **y** contiene el "Protocolo de inicio" y el "Protocolo de
      cierre" en línea. (Es el respaldo que funciona aunque no haya skills/agentes nativos.)

### 1.2 Skills de opencode
- [ ] `.opencode/skills/startup-protocol/SKILL.md`
- [ ] `.opencode/skills/closing-protocol/SKILL.md`
- [ ] `.opencode/skills/register-harness/SKILL.md` — **autosuficiencia**: permite re-sincronizar el
      harness desde dentro de opencode sin depender de Claude Code (resuelve la bootstrap-paradoja).
  > El contenido sale tal cual de `.claude/skills/<nombre>/SKILL.md` (formato compatible).

### 1.3 Agentes de opencode
- [ ] `.opencode/agents/sesion-starter.md`
- [ ] `.opencode/agents/sesion-closer.md`
  > Requieren traducir el frontmatter de Claude → opencode (ver tablas de mapeo abajo).

---

## Paso 2 — Reporte de auditoría

Presentar al usuario una tabla clara con el estado, por ejemplo:

```
Auditoría del harness para opencode
-----------------------------------
[✅/❌] AGENTS.md con protocolos en línea (baseline)
[✅/❌] .opencode/skills/startup-protocol/SKILL.md
[✅/❌] .opencode/skills/closing-protocol/SKILL.md
[✅/❌] .opencode/agents/sesion-starter.md
[✅/❌] .opencode/agents/sesion-closer.md
```

Para cada ❌, indicar:
- **Qué falta** y su ubicación destino.
- **De dónde saldría** (archivo fuente en `.claude/` o `AGENTS.md`).
- **Qué transformación** necesita (copia directa para skills; traducción de frontmatter para agentes).

Cerrar con un resumen: *"opencode está LISTO"* (todo ✅) o *"faltan N elementos"* con la lista.

Si faltan elementos, **ofrecer provisionarlos** (Paso 3) y esperar la confirmación del usuario.
Si el usuario no confirma, terminar aquí sin escribir nada.

---

## Paso 3 — Provisionar destino: opencode  (SOLO con confirmación)

> **Puerta de confirmación.** No ejecutar este paso sin que el usuario haya pedido/confirmado la
> provisión. Antes de escribir, enumerar los archivos exactos que se van a crear y pedir el visto
> bueno. Si el usuario dice que no, no se escribe nada.

Provisionar = crear **solo los elementos ❌** detectados en la auditoría, a partir de la fuente.
Los elementos ✅ **no se sobrescriben** salvo que el usuario pida re-sincronizar (ver *Re-sync*).

### 3.1 Baseline: `AGENTS.md`
- Si `AGENTS.md` **no existe** en la raíz: informarlo y detenerse en este punto. `AGENTS.md` es la
  fuente agnóstica con los protocolos en línea; no se genera desde `.claude/` (es al revés). Pedir
  al usuario que lo aporte (en este harness vive en `template/AGENTS.md`) antes de continuar.
- Si existe pero **no contiene** ambos protocolos en línea: advertirlo (el baseline queda incompleto),
  pero se puede continuar con skills/agentes nativos.

### 3.2 Skills — copia directa
Para cada skill que falte, crear la ruta y copiar el contenido **sin modificar**:

| Fuente | Destino |
|---|---|
| `.claude/skills/startup-protocol/SKILL.md` | `.opencode/skills/startup-protocol/SKILL.md` |
| `.claude/skills/closing-protocol/SKILL.md` | `.opencode/skills/closing-protocol/SKILL.md` |
| `.claude/skills/register-harness/SKILL.md` | `.opencode/skills/register-harness/SKILL.md` |

El `SKILL.md` de opencode admite el mismo frontmatter (`name`, `description`) y cuerpo Markdown, así
que la copia es byte a byte.

> **Copiar también el propio `register-harness`.** Es lo que hace a opencode **autosuficiente**: una
> vez provisionado, un agente en opencode tiene el skill nativo para volver a auditar/provisionar y
> re-sincronizar, sin depender de Claude Code. Resuelve la bootstrap-paradoja. El skill funciona
> igual en cualquier herramienta porque su fuente son archivos de texto (`.claude/…`) que se leen con
> las tools de archivo, no una capacidad exclusiva de Claude.

### 3.3 Agentes — traducción de frontmatter
Para cada agente que falte, leer la fuente `.claude/agents/<nombre>.md`, transformar **solo el
frontmatter** y conservar el cuerpo tal cual como `prompt`. Escribir en
`.opencode/agents/<nombre>.md`.

**Mapeo de campos (Claude → opencode):**

| Claude (`.claude/agents/*.md`) | opencode (`.opencode/agents/*.md`) | Regla |
|---|---|---|
| `name:` | *(se elimina)* | el id del agente = nombre de archivo |
| `description:` | `description:` | se conserva igual |
| *(implícito: es subagente)* | `mode: subagent` | se añade siempre |
| `model:` (shorthand) | `model:` (id destino) | ver tabla de modelos |
| `color:` | *(se elimina)* | opencode no tiene este campo |
| `tools: A, B, C` (lista CSV) | `tools:` (mapa booleano) | ver tabla de tools |
| *(cuerpo del archivo)* | *(cuerpo = `prompt`)* | se conserva sin cambios |

**Tabla de modelos (por agente del harness → id destino en opencode):**

El modelo NO se traduce desde el shorthand de Claude, porque opencode se usa aquí por
**suscripción** (no por API de Anthropic) y el usuario trabaja con sus propios modelos. Cada agente
del harness tiene asignado un modelo destino fijo:

| Agente | Modelo destino en opencode | Rol |
|---|---|---|
| `sesion-starter` | `openai/gpt-5.6-luna` | sesión de inicio, solo lectura |
| `sesion-closer` | `openai/gpt-5.6-terra` | sesión de cierre, escribe memoria |

> Nota: `openai/gpt-5.6-luna` y `openai/gpt-5.6-terra` son los ids (`proveedor/modelo`) configurados
> por el usuario en opencode (trabaja por suscripción, no por API de Anthropic). opencode no valida
> el id del modelo al arrancar; si no existe en la config del usuario, cae al modelo de la sesión.
> Si en el futuro se añaden más agentes, asignarles aquí su modelo destino.

**Tabla de tools (Claude → opencode):** los nombres pasan a minúsculas y se expresan como mapa
`herramienta: true`. Para un agente de **solo lectura**, además, deshabilitar explícitamente la
escritura con `write: false` y `edit: false`.

| Claude | opencode |
|---|---|
| `Read` | `read: true` |
| `Write` | `write: true` |
| `Edit` | `edit: true` |
| `Glob` | `glob: true` |
| `Grep` | `grep: true` |
| `Bash` | `bash: true` |
| `Skill` | `skill: true` |

**Resultado esperado para los dos agentes del harness:**

`.opencode/agents/sesion-starter.md` (solo lectura → `openai/gpt-5.6-luna`, sin escritura):
```markdown
---
description: >-
  <misma description que la fuente>
mode: subagent
model: openai/gpt-5.6-luna
tools:
  read: true
  glob: true
  grep: true
  bash: true
  skill: true
  write: false
  edit: false
---

<cuerpo idéntico al de .claude/agents/sesion-starter.md>
```

`.opencode/agents/sesion-closer.md` (escribe memoria → `openai/gpt-5.6-terra`):
```markdown
---
description: >-
  <misma description que la fuente>
mode: subagent
model: openai/gpt-5.6-terra
tools:
  read: true
  write: true
  edit: true
  glob: true
  grep: true
  bash: true
  skill: true
---

<cuerpo idéntico al de .claude/agents/sesion-closer.md>
```

### 3.4 Reporte de provisión
Tras escribir, listar los archivos creados y volver a correr la auditoría (Paso 1) para confirmar
que ahora todo está ✅. Cerrar con: *"opencode provisionado — N elementos creados"*.

### Re-sync (opcional)
Si el usuario pide **re-sincronizar** (la fuente cambió y quiere propagar), repetir el Paso 3
sobrescribiendo los destinos existentes con la versión actual de la fuente. Fuera de ese caso, no
se toca lo que ya está presente.

---

## Paso 4 — Destino: Gemini CLI  (auditar + provisionar)

Gemini CLI busca sus componentes en estas ubicaciones (verificado en su documentación oficial):

| Componente | Ubicación en Gemini CLI | ¿Contenido reutilizable desde la fuente? |
|---|---|---|
| Instrucciones | `AGENTS.md` (raíz) o `GEMINI.md` (puntero) | Sí — mismo archivo agnóstico |
| Skills | `.gemini/skills/<nombre>/SKILL.md` | **Sí** — mismo formato `SKILL.md`; copia directa |
| Agentes (subagentes) | `.gemini/agents/<nombre>.md` | Parcial — requiere **traducir el frontmatter** |

> Gemini CLI tiene **skills nativas** (herramienta `activate_skill`) y **subagentes nativos**, con las
> mismas rutas de proyecto que opencode. A nivel de usuario serían `~/.gemini/skills/` y
> `~/.gemini/agents/`; aquí provisionamos a nivel de **proyecto** (`.gemini/`), que es lo que se
> comparte al clonar el repo.

### 4.1 Auditar (solo lectura) — anotar ✅ presente / ❌ falta
- [ ] `AGENTS.md` en la raíz con ambos protocolos en línea (baseline).
- [ ] `.gemini/skills/startup-protocol/SKILL.md`
- [ ] `.gemini/skills/closing-protocol/SKILL.md`
- [ ] `.gemini/skills/register-harness/SKILL.md` — **autosuficiencia** (re-sincronizar desde Gemini).
- [ ] `.gemini/agents/sesion-starter.md`
- [ ] `.gemini/agents/sesion-closer.md`

### 4.2 Reporte y puerta de confirmación
Igual que en opencode (Paso 2): presentar la tabla ✅/❌ y, si faltan elementos, **ofrecer
provisionar** enumerando los archivos a crear y esperar confirmación explícita. Sin confirmación, no
se escribe nada.

### 4.3 Provisionar (SOLO con confirmación)

**Skills — copia directa** (byte a byte, incluido el propio `register-harness` para autosuficiencia):

| Fuente | Destino |
|---|---|
| `.claude/skills/startup-protocol/SKILL.md` | `.gemini/skills/startup-protocol/SKILL.md` |
| `.claude/skills/closing-protocol/SKILL.md` | `.gemini/skills/closing-protocol/SKILL.md` |
| `.claude/skills/register-harness/SKILL.md` | `.gemini/skills/register-harness/SKILL.md` |

**Agentes — traducción de frontmatter (Claude → Gemini CLI):**

| Claude (`.claude/agents/*.md`) | Gemini (`.gemini/agents/*.md`) | Regla |
|---|---|---|
| `name:` | `name:` | **se conserva** (Gemini lo usa como identificador) |
| `description:` | `description:` | se conserva igual |
| *(implícito: es subagente)* | `kind: local` | se añade siempre |
| `model:` (shorthand) | `model:` (id Gemini) | ver tabla de modelos |
| `color:` | *(se elimina)* | Gemini no tiene este campo |
| `tools: A, B, C` (lista CSV) | `tools:` (lista YAML) | nombres nativos, ver tabla de tools |
| *(cuerpo del archivo)* | *(cuerpo = system prompt)* | se conserva sin cambios |

**Tabla de tools (Claude → Gemini CLI):** Gemini usa nombres propios y una **lista** (allowlist).
Para un agente de **solo lectura** basta con **no incluir** las tools de escritura (`write_file`,
`replace`) — no hace falta el `write:false` de opencode.

| Claude | Gemini CLI |
|---|---|
| `Read` | `read_file` |
| `Write` | `write_file` |
| `Edit` | `replace` |
| `Glob` | `glob` |
| `Grep` | `grep_search` |
| `Bash` | `run_shell_command` |
| `Skill` | `activate_skill` |

**Tabla de modelos (por agente del harness → id destino en Gemini):**

| Agente | Modelo destino en Gemini | Rol |
|---|---|---|
| `sesion-starter` | `gemini-3-flash` | sesión de inicio, solo lectura |
| `sesion-closer` | `gemini-3-pro` | sesión de cierre, escribe memoria |

> Ajustar estos ids a los modelos que el usuario tenga disponibles en su Gemini CLI. Gemini no valida
> el id al arrancar; si no existe en su configuración, cae al modelo de la sesión. Si en el futuro se
> añaden más agentes, asignarles aquí su modelo destino.

**Resultado esperado para los dos agentes del harness:**

`.gemini/agents/sesion-starter.md` (solo lectura → `gemini-3-flash`, sin tools de escritura):
```markdown
---
name: sesion-starter
description: >-
  <misma description que la fuente>
kind: local
model: gemini-3-flash
tools:
  - read_file
  - glob
  - grep_search
  - run_shell_command
  - activate_skill
---

<cuerpo idéntico al de .claude/agents/sesion-starter.md>
```

`.gemini/agents/sesion-closer.md` (escribe memoria → `gemini-3-pro`):
```markdown
---
name: sesion-closer
description: >-
  <misma description que la fuente>
kind: local
model: gemini-3-pro
tools:
  - read_file
  - write_file
  - replace
  - glob
  - grep_search
  - run_shell_command
  - activate_skill
---

<cuerpo idéntico al de .claude/agents/sesion-closer.md>
```

### 4.4 Reporte de provisión
Tras escribir, listar los archivos creados y volver a auditar (Paso 4.1) para confirmar que todo
está ✅. Cerrar con: *"Gemini provisionado — N elementos creados"*. El **re-sync** funciona igual que
en opencode (sobrescribe los destinos con la versión actual de la fuente, solo si el usuario lo pide).

---

## Extensibilidad (próximas iteraciones)

Para añadir otra herramienta, replicar los pasos de auditoría/provisión con su mapa de ubicaciones y
su traducción:

- **Codex:** skills en `.agents/skills/<n>/SKILL.md` (formato compatible); agentes en
  `~/.codex/agents/*.toml` (TOML, a nivel de usuario) o solo skills. **Por verificar** con doc oficial
  antes de implementar.

---

## Reglas invariantes

- **La fuente de verdad es `.claude/` (+ `AGENTS.md`);** el destino es un reflejo, nunca al revés.
- **Auditar es de solo lectura.** Provisionar **solo** ocurre con confirmación explícita del usuario
  y tras enumerar los archivos que se van a crear.
- **No sobrescribir** elementos ya presentes salvo re-sync explícito.
- **No inventar contenido:** los skills se copian tal cual; en los agentes solo se traduce el
  frontmatter y se conserva el cuerpo intacto.
- Idioma: comunicarse en el idioma del proyecto (por defecto, español).
