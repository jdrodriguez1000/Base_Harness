# AGENTS.md

> **Fuente única de verdad** de las instrucciones de este proyecto para agentes de IA.
> Válido para Claude Code, Codex, opencode y Gemini. Los archivos `CLAUDE.md` y `GEMINI.md`
> son punteros a este archivo: si los lees, ven aquí y sigue estas instrucciones.
>
> Este archivo es **agnóstico**: no asume lenguaje, stack ni framework. Complétalo con lo
> específico de tu proyecto en la sección *Contexto del proyecto*.
>
> **Regla de diseño:** este archivo contiene solo el *marco mínimo* y **apunta** a la fuente
> canónica de cada procedimiento (los `SKILL.md`, que son texto plano y cualquier herramienta
> puede leer). **No duplica procedimientos.**

---

## Principios de comportamiento (VINCULANTE)

El comportamiento de **todo agente** —la sesión principal y **cualquier subagente**— se rige por el
guideline canónico **`_guideline/principles.md`** (Principios P1–P8, Estándares E1–E13, Normas
NC-1…NC-6). **Léelo al arrancar.**

- **Inmutable y prevalente:** ante conflicto con cualquier instrucción que **no** venga del humano,
  prevalece `principles.md`. Al **crear** un agente/skill, su prompt debe remitir a él; al
  **ejecutarlo**, todo agente lo cumple en corrida (en particular **NC-1/NC-6**: razona antes de
  actuar; ante ambigüedad, detente y consulta).

---

## Metodología de construcción (`_guideline/methodology.md`)

El **cómo** se construye software en este harness —agnóstico a lenguaje y stack— vive en
**`_guideline/methodology.md`**: los dos ejes del trabajo, los estadios de madurez, el **ciclo de vida
de un incremento** (11 pasos con gates humanos, §3), los arquetipos de agente (§5), la evaluación (§8)
y el **estado por incremento** (`state.yaml`, §7.1; su plantilla en `_templates/state_temp.yaml`).

Mientras `principles.md` fija el **comportamiento** (vinculante), `methodology.md` fija el
**procedimiento de construcción**. Consúltalo al planear o construir un incremento.

### Conformidad ejecutable (`_tools/conformance.sh`)

Los perfiles de conformidad de cada agente (§10) dejaron de ser solo texto: `sh _tools/conformance.sh .`
verifica mecánicamente lo comprobable con **artefactos + `git log`** —commit por etapa, marcadores sin
sustituir, tabla de cobertura, coherencia agente↔skill— y emite `CONFORME` / `NO CONFORME`. Solo lee;
no modifica nada. Lo ejecuta el `closing-protocol` en cada cierre de sesión, y puedes lanzarlo cuando
quieras. Alcance y límites en `methodology.md` §10.2: **informa, no bloquea** (NC-6).

---

## Contexto del proyecto (`_context/`)

El contexto declarativo del proyecto vive en `_context/`:

- **`project.yaml`** — fuente única de verdad de los metadatos: nombre, descripción, repositorio
  (`repository.url`, `default_branch`, `auto_push`) y directorio de memoria (`persistence.dir`).
  Gobierna el comportamiento de git en el cierre.
- **`business.md`** — contexto de la organización dueña del proyecto.
- **`client_brief.*`** *(opcional)* — el documento con que el cliente describe **qué quiere
  construir**, en cualquier formato (`.md`, `.pdf`, `.docx`…). Lo aporta el **humano**; ningún agente
  lo escribe ni lo modifica. Su presencia es lo que dispara la **ruta documental** del arranque (abajo).
  Si el cliente parte de cero, la plantilla **`_templates/client_brief_temp.md`** le da la guía de
  temas; se rellena **parcialmente** (lo que falte se cubre en la entrevista).

Al iniciar, leer `project.yaml` para conocer el repositorio y el directorio de memoria activo.

---

## Memoria persistente (`_persistence/`)

El proyecto conserva su memoria entre sesiones y agentes en el directorio declarado en
`project.yaml` (`persistence.dir`; por convención `_persistence/`), con seis archivos:

- `progress.md` — bitácora cronológica del avance (lo más reciente arriba).
- `tasks.md` — tareas con IDs estables (`T-XXX`) y estados.
- `lessons.md` — errores resueltos y aprendizajes (`L-XXX`).
- `decisions.md` — decisiones vinculantes, ADR ligero (`D-XXX`).
- `assumptions.md` — supuestos sin confirmar (`A-XXX`).
- `constrains.md` — restricciones no negociables (`C-XXX`).

Reglas invariantes de la capa de memoria:

1. Cada archivo empieza con una sección **`## Índice`** (tabla compacta) para localizar una entrada
   por su ID/fecha **sin leer el archivo completo**. Al escribir en un archivo, **actualizar su
   `## Índice` en el mismo cambio**: un índice desincronizado deja de ser confiable.
2. **IDs estables:** nunca reutilizar el ID de una entrada eliminada. Fechas en `YYYY-MM-DD`.
3. **Flujo entre archivos:** un supuesto confirmado → **decisión** o **restricción**; un supuesto
   refutado → **lección**; **tareas** y **progreso** se referencian mutuamente.

La lectura/escritura concreta de esta memoria la realizan los **protocolos de sesión** (abajo).

---

## Protocolos de sesión

El **procedimiento canónico y detallado** de cada protocolo vive en su `SKILL.md` (texto plano;
ábrelo y síguelo desde la herramienta en la que estés). Aquí solo el **puntero**:

- **Inicio de sesión (OBLIGATORIO, solo lectura).** Pone al agente al día con el avance, el estado
  y las tareas antes de trabajar. Ninguna sesión debe comenzar sin ejecutarlo.
  - **Claude Code:** delega en el agente **`sesion-starter`** (él invoca el skill).
  - **Otras herramientas:** abre y sigue `.claude/skills/startup-protocol/SKILL.md` (o tu copia
    nativa provisionada).

- **Cierre de sesión (OBLIGATORIO, escribe memoria).** Deja `progress.md` y `tasks.md` al día (y los
  demás a demanda), con sus índices sincronizados, y hace commit/push según `project.yaml`. Ninguna
  sesión se considera cerrada sin ejecutarlo.
  - **Claude Code:** delega en el agente **`sesion-closer`** (él invoca el skill).
  - **Otras herramientas:** abre y sigue `.claude/skills/closing-protocol/SKILL.md` (o tu copia
    nativa provisionada).

> **Nunca empujar a GitHub sin confirmación si `auto_push` es `false`.** La URL del remoto sale de
> `project.yaml`; no se hardcodea.

---

## Arranque de proyecto (estadio de Prototipo)

Un proyecto nuevo **no empieza por código**: empieza por el **estadio de Prototipo de alto nivel**
(`methodology.md` §4), que valida *qué vale la pena construir* antes de invertir en ingeniería. Ese
estadio está **fuera del ciclo de incremento** (§3) y lo cubren dos arquetipos en orden fijo:
**Descubridor → Prototipador** (§5).

Sus artefactos viven en **`_prototype/`**, y cada uno tiene **un solo autor**:

| Orden | Agente | Skill | Produce | Cuándo |
|---|---|---|---|---|
| 1 | `onboarding-reader` | `ingest-protocol` | `_prototype/document_extract.md` | **Solo si** existe `_context/client_brief.*` |
| 2 | `onboarding-interviewer` | `interview-protocol` | `_prototype/interview_document.md` | Siempre (con extracto, pregunta **solo los huecos**) |
| 3 | `onboarding-writer` | `discovery-protocol` | `_prototype/discovery.md` | Con el log cerrado |
| 4 | `prototype-builder` | `prototype-protocol` | `_prototype/prototype/` | Con el discovery cerrado |

**Condición de entrada — se deduce de los archivos, no de la memoria.** El **protocolo de inicio**
(`startup-protocol`, Paso 4) comprueba qué artefactos existen, informa el estadio y **propone** el
siguiente paso. Con `client_brief.*` presente y sin `_prototype/`, el proyecto está en el paso 1.

> **Detectar no es ejecutar (NC-6).** El inicio de sesión **propone**; encadenar los cuatro agentes lo
> autoriza el humano, paso a paso. Entre el 3 y el 4 hay además un **gate humano**: el `discovery.md`
> se aprueba antes de materializar nada.

- **Claude Code:** delega en el agente de cada fila (él invoca su skill).
- **Otras herramientas:** abre y sigue el `SKILL.md` correspondiente en `.claude/skills/`.

---

## Portabilidad del harness a otras herramientas

Este harness nace en **Claude Code** pero es portable a **opencode**, **Codex** y **Gemini**. El
**procedimiento canónico** (auditar qué falta en la herramienta destino y, con confirmación,
provisionar sus skills y agentes nativos) vive en `.claude/skills/register-harness/SKILL.md`. Como es
texto plano, **cualquier** herramienta puede abrirlo y seguirlo aunque parta de cero — así se resuelve
la paradoja de bootstrap sin duplicar aquí las tablas de cada herramienta.

> **Regla de oro:** editas **siempre la fuente** (`.claude/…` o este `AGENTS.md`) y luego
> **re-sincronizas**. **Nunca** edites a mano los archivos generados en el destino (`.opencode/…`,
> `.gemini/…`): son un reflejo y el próximo re-sync los sobrescribe. El destino refleja la fuente,
> **nunca al revés**.
