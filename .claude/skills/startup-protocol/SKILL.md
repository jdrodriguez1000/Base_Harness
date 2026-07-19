---
name: startup-protocol
description: >-
  Protocolo de inicio de sesión. Al comenzar a trabajar en el proyecto, el agente lee la memoria
  persistente para conocer el avance, el estado, las tareas realizadas y las próximas tareas antes
  de hacer cualquier cosa. Úsalo al iniciar una sesión, retomar el trabajo o cuando el usuario diga
  "protocolo de inicio", "startup protocol", "ponte al día", "retoma el proyecto" o similar.
  Obligatorio leer progress.md y tasks.md; los otros cuatro archivos (lessons, decisions,
  assumptions, constrains) se leen solo a demanda. Lee además el estado real del repositorio (git
  log, status y rama) para contrastarlo con lo que declara la memoria. Detecta el ESTADIO del proyecto por la
  presencia de artefactos (_context/client_brief.*, _prototype/…) y propone el siguiente paso con el
  agente que le corresponde. Agnóstico: funciona en cualquier proyecto que use la capa de
  persistencia estándar.
---

# Startup Protocol — Protocolo de inicio de sesión

Objetivo: que el agente **se ponga al día** con el estado real del proyecto antes de trabajar,
leyendo la **memoria persistente**. Así ninguna sesión empieza a ciegas: se conoce qué se hizo,
en qué punto quedó todo y qué falta por hacer.

Este skill es **agnóstico al proyecto**: no asume stack, lenguaje ni estructura particular, solo
la existencia de la capa de persistencia estándar.

---

## Paso 0 — Cargar el contexto y determinar el directorio de memoria

1. **Localizar `project.yaml`** (contexto declarativo del proyecto):
   - `_context/project.yaml` en la raíz del proyecto; si no existe,
   - una carpeta **de la raíz** cuyo nombre **termine en `_context`** (p. ej. una variante con
     prefijo numérico) que contenga `project.yaml`.
2. **Si hay `project.yaml`:** leer `persistence.dir` → ese es el directorio de memoria activo.
3. **Si no hay `project.yaml`** (respaldo): usar `_persistence/` en la raíz o, si no, una carpeta
   **de la raíz** cuyo nombre **termine en `_persistence`** que contenga `progress.md` y `tasks.md`.
4. Si no se encuentra memoria por ninguna vía, informar al usuario: el proyecto aún no tiene capa
   de persistencia inicializada.

En adelante, `<MEM>` = el directorio de memoria activo detectado.

---

## Paso 1 — (OBLIGATORIO) Leer `progress.md`

Leer `<MEM>/progress.md` completo o, si es extenso, empezar por su `## Índice` y luego las entradas
más recientes del historial. Extraer:

- El **estado global** del proyecto y el último hito.
- El **"siguiente paso"** declarado en la entrada más reciente.
- Cualquier bloqueo o pendiente inmediato.

---

## Paso 2 — (OBLIGATORIO) Leer `tasks.md`

Leer `<MEM>/tasks.md`. Usar el `## Índice` para tener el panorama y luego revisar:

- Tareas **en progreso** `[~]` y **bloqueadas** `[!]` (prioridad de atención).
- Tareas **pendientes** `[ ]` del backlog (próximas tareas).
- Tareas **completadas** `[x]` recientemente (contexto de lo ya hecho).

---

## Paso 3 — (A DEMANDA) Leer los otros cuatro archivos

Consultarlos **solo si la tarea del momento lo requiere**, usando su `## Índice` para ir directo a
la entrada relevante sin leer todo el archivo:

| Archivo | Leer cuando... |
|---|---|
| `decisions.md` | Se va a tomar o revisar una decisión, o hay que respetar una decisión previa (`D-XXX`). |
| `constrains.md` | Se necesita conocer las restricciones no negociables que acotan el trabajo (`C-XXX`). |
| `assumptions.md` | Hay que validar o apoyarse en supuestos aún no confirmados (`A-XXX`). |
| `lessons.md` | Se aborda algo donde conviene no repetir errores previos (`L-XXX`). |

---

## Paso 4 — (OBLIGATORIO) Leer el estado del repositorio

La memoria dice lo que el agente **escribió**; git dice lo que **quedó**. Cuando divergen, git manda:
un cierre de sesión puede haberse interrumpido antes de actualizar `progress.md`, o haber dejado
trabajo sin confirmar. Verificar el ambiente real antes de trabajar es E1/E10.

1. **Comprobar si el proyecto es repo git** (`git rev-parse --git-dir`). Si no lo es, informarlo como
   **hallazgo** en el resumen —el proyecto está corriendo sin control de versiones (L-009)— y saltar
   al Paso 5. **No inicializar nada aquí:** este protocolo es de solo lectura; el bootstrap le
   corresponde a la etapa que vaya a confirmar (`_guideline/git-protocol.md` §2).
2. **Leer el historial reciente:** `git log --oneline -10`. Contrastar con lo que declara la última
   entrada de `progress.md`.
3. **Leer el árbol de trabajo:** `git status --short`. Cambios sin confirmar son trabajo de una sesión
   previa que no cerró bien: hay que **informarlos**, no confirmarlos por cuenta propia.
4. **Informar la rama actual.**

> **Divergencia = hallazgo, no corrección silenciosa (NC-6).** Si el historial no respalda lo que la
> memoria afirma —o al revés—, se **reporta al humano** en el Paso 6. El inicio de sesión no reconcilia
> memoria y repositorio por su cuenta.

---

## Paso 5 — (OBLIGATORIO) Detectar el estadio del proyecto

La memoria dice qué se hizo; **los artefactos dicen dónde está el proyecto**. Un proyecto recién
abierto tiene la memoria vacía pero puede tener ya el documento del cliente esperando: sin este paso,
nadie se da cuenta y el humano tiene que saber de memoria qué agente invocar.

Comprobar la **presencia de archivos** (no leer su contenido; basta con que existan) y deducir el
estadio por la **primera fila que aplique**, de arriba abajo:

| Si... | El proyecto está en... | Siguiente paso |
|---|---|---|
| existe `_prototype/prototype/` | Prototipo **materializado** | Evaluarlo con el humano (gate de madurez §4.4) |
| existe `_prototype/discovery.md` | Descubrimiento **cerrado** | Materializar el prototipo (`prototype-builder`) |
| existe `_prototype/interview_document.md` | Entrevista **en curso o cerrada** | Redactar el discovery (`onboarding-writer`); si el log sigue `en curso`, reanudar la entrevista |
| existe `_prototype/document_extract.md` | Documento **ingerido** | Entrevistar **solo los huecos** (`onboarding-interviewer`) |
| existe `_context/client_brief.*` | **Arranque con documento** | Ingerir el documento (`onboarding-reader`) |
| no existe ninguno de los anteriores | **Arranque sin documento** | Entrevista completa (`onboarding-interviewer`) |

> **Solo aplica al estadio de Prototipo.** Si el proyecto ya superó el gate §4.4 y trabaja por
> incrementos, el estado real vive en `_increments/<id>/state.yaml` (§7.1) y manda ese, no esta tabla.
> Compruébalo: si existe `_increments/`, informa el incremento abierto y su `paso_actual`.

---

## Paso 6 — Sintetizar y confirmar

1. Presentar al usuario un **resumen breve** del estado: último avance, en qué punto quedó el
   proyecto, tareas en curso y próximas tareas sugeridas.
2. **Informar el estado del repositorio** (Paso 4): rama, últimos commits y —si los hay— cambios sin
   confirmar o divergencias con la memoria.
3. **Informar el estadio detectado** en el Paso 5 y **proponer el siguiente paso** que le corresponde,
   nombrando el agente/skill concreto.
4. Proponer (o confirmar con el usuario) **en qué se va a trabajar** en esta sesión.

> **Proponer no es ejecutar (NC-6).** El inicio de sesión detecta y sugiere; **no** encadena agentes
> por su cuenta. Arrancar el descubrimiento o el prototipado lo autoriza el humano.

---

## Reglas invariantes

- `progress.md` y `tasks.md` son de lectura **siempre obligatoria** al iniciar; los otros cuatro,
  solo a demanda.
- No modificar la memoria en el inicio: este protocolo es de **lectura**. La escritura ocurre
  durante el trabajo y en el cierre (`closing-protocol`). La detección del estadio (Paso 5) tampoco
  escribe: comprueba **presencia** de archivos, no los altera ni crea carpetas.
- **La lectura del repositorio (Paso 4) es de solo lectura, sin excepción:** `log`, `status` y rama.
  Nada de `init`, `add`, `commit`, `checkout` ni `stash`. Los cambios sin confirmar que encuentres se
  **informan**; confirmarlos o descartarlos lo decide el humano (NC-6).
- **Detectar y proponer, nunca ejecutar.** El inicio informa en qué estadio está el proyecto y qué
  agente sigue; invocarlo es decisión del humano (NC-6).
- Idioma: comunicarse en el idioma del proyecto (por defecto, español).
