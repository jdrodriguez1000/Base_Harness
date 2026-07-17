---
name: startup-protocol
description: >-
  Protocolo de inicio de sesión. Al comenzar a trabajar en el proyecto, el agente lee la memoria
  persistente para conocer el avance, el estado, las tareas realizadas y las próximas tareas antes
  de hacer cualquier cosa. Úsalo al iniciar una sesión, retomar el trabajo o cuando el usuario diga
  "protocolo de inicio", "startup protocol", "ponte al día", "retoma el proyecto" o similar.
  Obligatorio leer progress.md y tasks.md; los otros cuatro archivos (lessons, decisions,
  assumptions, constrains) se leen solo a demanda. Agnóstico: funciona en cualquier proyecto que
  use la capa de persistencia estándar.
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

## Paso 4 — Sintetizar y confirmar

1. Presentar al usuario un **resumen breve** del estado: último avance, en qué punto quedó el
   proyecto, tareas en curso y próximas tareas sugeridas.
2. Proponer (o confirmar con el usuario) **en qué se va a trabajar** en esta sesión.

---

## Reglas invariantes

- `progress.md` y `tasks.md` son de lectura **siempre obligatoria** al iniciar; los otros cuatro,
  solo a demanda.
- No modificar la memoria en el inicio: este protocolo es de **lectura**. La escritura ocurre
  durante el trabajo y en el cierre (`closing-protocol`).
- Idioma: comunicarse en el idioma del proyecto (por defecto, español).
