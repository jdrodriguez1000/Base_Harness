# AGENTS.md

> **Fuente única de verdad** de las instrucciones de este proyecto para agentes de IA.
> Válido para Claude Code, Codex, opencode y Gemini. Los archivos `CLAUDE.md` y `GEMINI.md`
> son punteros a este archivo: si los lees, ven aquí y sigue estas instrucciones.
>
> Este archivo es **agnóstico**: no asume lenguaje, stack ni framework. Complétalo con lo
> específico de tu proyecto en la sección *Contexto del proyecto*.

---

## Principios de comportamiento (VINCULANTE)

El comportamiento de **todo agente** de este proyecto —la sesión principal (orquestador) y
**cualquier subagente** que ésta cree— se rige por el guideline canónico
**`_guideline/principles.md`**: los **Principios de Ingeniería (P1–P8)**, los **Estándares de
Comportamiento (E1–E13)** y las **Normas de Comportamiento (NC-1…NC-6)**.

- **Inmutable y prevalente:** ante conflicto entre `principles.md` y cualquier otra instrucción que
  **no** provenga del humano, prevalece `principles.md`.
- **Aplica en construcción y en uso:** al **crear** cualquier agente o skill, su prompt debe remitir
  a estos principios; al **ejecutarlo**, todo agente los cumple en tiempo de corrida.
- **Léelo al arrancar** y respétalo durante toda la sesión. En particular **NC-1 / NC-6**: razona
  antes de actuar y no tomes decisiones silenciosas; ante ambigüedad, detente y consulta.

Este `AGENTS.md` define el *marco operativo* (memoria, protocolos, portabilidad); `principles.md`
define el *comportamiento* que gobierna a los agentes que operan dentro de ese marco.

---

## Contexto del proyecto (`_context/`)

El contexto declarativo del proyecto vive en la carpeta `_context/`:

- **`project.yaml`** — fuente única de verdad de los metadatos: nombre, descripción, repositorio
  (`repository.url`, `default_branch`, `auto_push`) y directorio de memoria (`persistence.dir`).
- **`business.md`** — contexto de la organización dueña del proyecto.

Al iniciar, leer `_context/project.yaml` para conocer el repositorio y el directorio de memoria
activo. Este archivo gobierna el comportamiento de git en el cierre (ver *Protocolo de cierre*).

---

## Memoria persistente (`_persistence/`)

El proyecto conserva su memoria entre sesiones y entre agentes en el directorio declarado en
`_context/project.yaml` (`persistence.dir`; por convención `_persistence/`), con seis archivos:

- `progress.md` — bitácora cronológica del avance (lo más reciente arriba).
- `tasks.md` — tareas con IDs estables (`T-XXX`) y estados.
- `lessons.md` — errores resueltos y aprendizajes (`L-XXX`).
- `decisions.md` — decisiones vinculantes, ADR ligero (`D-XXX`).
- `assumptions.md` — supuestos sin confirmar (`A-XXX`).
- `constrains.md` — restricciones no negociables (`C-XXX`).

Cada archivo empieza con una sección **`## Índice`** (tabla compacta) que permite localizar una
entrada por su ID/fecha **sin leer el archivo completo**.

### Reglas de trabajo

1. **Al iniciar sesión:** ejecutar el **Protocolo de inicio** (abajo). Es OBLIGATORIO.
2. **Durante el trabajo:** al escribir en cualquier archivo de persistencia, actualizar su
   `## Índice` en el mismo cambio. Un índice desincronizado deja de ser confiable.
3. **IDs estables:** nunca reutilizar el ID de una entrada eliminada. Fechas en formato `YYYY-MM-DD`.
4. **Al cerrar sesión:** ejecutar el **Protocolo de cierre** (abajo). Es OBLIGATORIO.

### Flujo entre archivos

- Un **supuesto** confirmado → se promueve a **decisión** o **restricción**.
- Un supuesto refutado → genera una **lección**.
- **Tareas** y **progreso** se referencian mutuamente.

---

## Protocolo de inicio de sesión (OBLIGATORIO)

**Ninguna sesión debe comenzar sin ejecutar antes este protocolo.** Evita empezar a ciegas: pone al
agente al día con el avance, el estado y las tareas del proyecto. Es de **solo lectura**.

> **Atajo para Claude Code:** puedes invocar el skill `startup-protocol` o el agente
> `sesion-starter`. Otros agentes (Codex, opencode, Gemini) deben seguir el procedimiento manual
> descrito a continuación.

### Procedimiento

1. **(OBLIGATORIO) Leer `progress.md`:** revisar el `## Índice` y las entradas más recientes del
   historial. Extraer el estado global, el último hito y el "siguiente paso" declarado.

2. **(OBLIGATORIO) Leer `tasks.md`:** con ayuda del `## Índice`, revisar tareas en progreso `[~]`,
   bloqueadas `[!]`, pendientes `[ ]` (próximas tareas) y completadas `[x]` recientes.

3. **(A DEMANDA) los otros cuatro archivos**, solo si la tarea del momento lo requiere (usar su
   `## Índice` para ir directo a la entrada relevante):
   - `decisions.md` → hay que tomar/revisar una decisión o respetar una previa (`D-XXX`).
   - `constrains.md` → se necesita conocer las restricciones que acotan el trabajo (`C-XXX`).
   - `assumptions.md` → hay que validar o apoyarse en supuestos sin confirmar (`A-XXX`).
   - `lessons.md` → conviene no repetir errores previos (`L-XXX`).

4. **Sintetizar y confirmar:** presentar al usuario un resumen breve del estado (último avance,
   punto en que quedó el proyecto, tareas en curso y próximas) y proponer en qué trabajar.

> Este protocolo NO modifica la memoria. La escritura ocurre durante el trabajo y en el cierre.

## Protocolo de cierre de sesión (OBLIGATORIO)

**Ninguna sesión se considera cerrada hasta ejecutar este protocolo.** Deja la memoria al día
para el próximo agente.

> **Atajo para Claude Code:** puedes invocar el skill `closing-protocol` o el agente
> `sesion-closer`. Otros agentes (Codex, opencode, Gemini) deben seguir el procedimiento manual
> descrito a continuación.

### Procedimiento

1. **Recopilar lo realizado:** repasar la conversación de la sesión y, si hay git, `git status` /
   `git diff`. Identificar tareas completadas, decisiones, problemas resueltos, supuestos,
   restricciones y tareas pendientes.

2. **(OBLIGATORIO) `progress.md`:** añadir una entrada nueva al inicio del historial (estado,
   resumen, siguiente paso, referencias) y actualizar su `## Índice`.

3. **(OBLIGATORIO) `tasks.md`:** marcar completadas `[x]`, mover en progreso `[~]` / bloqueadas
   `[!]`, añadir las tareas futuras con IDs nuevos (`T-XXX`), y actualizar su `## Índice`.

4. **(A DEMANDA) los otros cuatro archivos**, solo si aplica:
   - `decisions.md` → se tomó una decisión relevante (`D-XXX`).
   - `lessons.md` → se resolvió un error o se aprendió algo no obvio (`L-XXX`).
   - `assumptions.md` → se asumió algo sin confirmar, o se confirmó/refutó un supuesto (`A-XXX`).
   - `constrains.md` → apareció una restricción firme (`C-XXX`).
   En cada archivo que se toque, actualizar su `## Índice`.

5. **Verificar y confirmar:** todos los índices tocados sincronizados; ninguna entrada del cuerpo
   sin su fila en el índice. Presentar al usuario un resumen breve de lo actualizado.

6. **(Git) Commit & push**, usando la sección `repository` de `_context/project.yaml`:
   - Si el proyecto no es un repo git, **omitir** este paso.
   - Si no hay `origin` y `repository.url` está definido, configurarlo (`git remote add origin <url>`).
     `project.yaml` es la fuente de la URL; no hardcodear ninguna URL.
   - `git add -A` y `git commit` con un mensaje que resuma la sesión.
   - Push según `auto_push`: si `true`, `git push`; si `false` (o ausente), **no** empujar sin
     **confirmación explícita** del usuario.

### Reglas invariantes

- `progress.md` y `tasks.md` son **siempre obligatorios**; los otros cuatro, solo a demanda.
- No inventar trabajo: registrar únicamente lo que realmente ocurrió en la sesión.
- Nunca empujar a GitHub sin confirmación si `auto_push` es `false`. La URL sale de `project.yaml`.
- Idioma de la memoria: el del proyecto (por defecto, español).

---

## Portabilidad del harness a otras herramientas (`register-harness`)

Este harness nace en **Claude Code**, pero está pensado para usarse también en **opencode**, **Codex**
y **Gemini**. El mecanismo que lo hace portable se llama **`register-harness`**: audita qué falta en
una herramienta destino y, con tu confirmación, la **provisiona** (crea sus skills y agentes nativos).

> **Por qué esta sección existe (bootstrap).** `register-harness` es, en Claude Code, un skill. Si
> estás en **otra** herramienta y aún no se ha provisionado, no tendrías el skill nativo para
> arrancar. Por eso el procedimiento se describe aquí, en `AGENTS.md`, que **todas** las herramientas
> leen. Con esto, cualquier agente puede portar el harness aunque parta de cero.

### Fuente única de verdad

La base canónica son **archivos de texto plano** (no una app concreta). Cualquier herramienta puede
leerlos con sus tools de archivo:

- Skills: `.claude/skills/startup-protocol/SKILL.md`, `.claude/skills/closing-protocol/SKILL.md`,
  `.claude/skills/register-harness/SKILL.md`
- Agentes: `.claude/agents/sesion-starter.md`, `.claude/agents/sesion-closer.md`
- Instrucciones agnósticas: este `AGENTS.md`.
- Guideline de comportamiento (VINCULANTE): `_guideline/principles.md` — parte del baseline; vive en
  la raíz del proyecto y lo leen todas las herramientas vía `AGENTS.md`.

El **procedimiento detallado y canónico** vive en `.claude/skills/register-harness/SKILL.md`. Como es
un archivo Markdown, **ábrelo y síguelo** desde la herramienta en la que estés. Esta sección es el
resumen autosuficiente para arrancar.

### Regla de oro

Editas **siempre la fuente** (`.claude/…` o este `AGENTS.md`) y luego **re-sincronizas**. **Nunca**
edites a mano los archivos generados en el destino (`.opencode/…`): son un reflejo y el próximo
re-sync los sobrescribe. El destino es un reflejo de la fuente, **nunca al revés**.

> **¿Y si estoy en opencode y debo ajustar un skill/agente?** No vuelves a Claude Code como *app*:
> editas el archivo fuente en `.claude/` (es solo texto) y ejecutas `register-harness` en modo
> re-sync. Tras la primera provisión, opencode tiene su propia copia nativa de `register-harness`
> (ver más abajo), así que puede re-sincronizarse por sí mismo.

### Procedimiento (destino: opencode)

**Ubicaciones en opencode** y transformación desde la fuente:

| Componente | Ubicación destino | Transformación |
|---|---|---|
| Instrucciones | `AGENTS.md` (raíz) | Ninguna — mismo archivo agnóstico |
| Skills | `.opencode/skills/<nombre>/SKILL.md` | **Copia directa** (formato `SKILL.md` compatible) |
| Agentes | `.opencode/agents/<nombre>.md` | **Traducir frontmatter** (ver tabla) |

1. **Auditar (solo lectura):** comprobar la presencia de cada elemento y anotar ✅/❌:
   - `AGENTS.md` en la raíz con los protocolos en línea (baseline).
   - `.opencode/skills/startup-protocol/SKILL.md`, `.opencode/skills/closing-protocol/SKILL.md`.
   - `.opencode/skills/register-harness/SKILL.md` (autosuficiencia: permite re-sincronizar desde opencode).
   - `.opencode/agents/sesion-starter.md`, `.opencode/agents/sesion-closer.md`.

2. **Provisionar (solo con confirmación):** crear los ❌. Enumerar primero los archivos que se van a
   crear y pedir el visto bueno. No sobrescribir lo presente salvo re-sync explícito.
   - **Skills** → copiar el contenido tal cual desde `.claude/skills/<nombre>/SKILL.md` (incluido el
     propio `register-harness`, para que opencode quede autosuficiente).
   - **Agentes** → traducir el frontmatter Claude → opencode y conservar el cuerpo como `prompt`.

3. **Confirmar:** re-auditar; todo debe quedar ✅.

**Traducción de frontmatter de agentes (Claude → opencode):**

| Claude | opencode | Regla |
|---|---|---|
| `name:` | *(se elimina)* | el id del agente = nombre de archivo |
| `description:` | `description:` | igual |
| *(implícito subagente)* | `mode: subagent` | se añade |
| `model:` | `model:` | asignar el modelo destino por agente (ver abajo) |
| `color:` | *(se elimina)* | opencode no tiene este campo |
| `tools: A, B` (CSV) | `tools:` (mapa `x: true`) | minúsculas; en solo-lectura, `write: false`, `edit: false` |
| *(cuerpo)* | *(cuerpo = `prompt`)* | igual |

**Modelos destino en opencode** (el usuario trabaja por suscripción, no por API de Anthropic):

| Agente | Modelo |
|---|---|
| `sesion-starter` | `openai/gpt-5.6-luna` |
| `sesion-closer` | `openai/gpt-5.6-terra` |

### Procedimiento (destino: Gemini CLI)

Gemini CLI tiene **skills** y **subagentes** nativos, con rutas de proyecto análogas a opencode.

| Componente | Ubicación destino | Transformación |
|---|---|---|
| Instrucciones | `AGENTS.md` (raíz) o `GEMINI.md` (puntero) | Ninguna — mismo archivo agnóstico |
| Skills | `.gemini/skills/<nombre>/SKILL.md` | **Copia directa** (formato `SKILL.md` compatible) |
| Agentes | `.gemini/agents/<nombre>.md` | **Traducir frontmatter** (ver tabla) |

Auditar y provisionar igual que en opencode (auditar ✅/❌ → confirmar → crear los ❌ → re-auditar),
incluyendo `.gemini/skills/register-harness/SKILL.md` para autosuficiencia.

**Traducción de frontmatter de agentes (Claude → Gemini CLI):**

| Claude | Gemini CLI | Regla |
|---|---|---|
| `name:` | `name:` | **se conserva** (Gemini lo usa como id) |
| `description:` | `description:` | igual |
| *(implícito subagente)* | `kind: local` | se añade |
| `model:` | `model:` | id Gemini por agente (ver abajo) |
| `color:` | *(se elimina)* | Gemini no tiene este campo |
| `tools: A, B` (CSV) | `tools:` (lista YAML) | nombres nativos; en solo-lectura, omitir `write_file`/`replace` |
| *(cuerpo)* | *(cuerpo = system prompt)* | igual |

**Tools (Claude → Gemini):** `Read`→`read_file`, `Write`→`write_file`, `Edit`→`replace`,
`Glob`→`glob`, `Grep`→`grep_search`, `Bash`→`run_shell_command`, `Skill`→`activate_skill`.

**Modelos destino en Gemini** (ajustar a los que tenga el usuario):

| Agente | Modelo |
|---|---|
| `sesion-starter` | `gemini-3-flash` |
| `sesion-closer` | `gemini-3-pro` |

### Otras herramientas

**Codex** sigue el mismo patrón (auditar → provisionar) con **sus propias ubicaciones y traducción**,
aún por implementar/verificar. Consulta `.claude/skills/register-harness/SKILL.md` para el estado
actual antes de portar a esa herramienta.
