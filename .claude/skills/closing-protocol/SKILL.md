---
name: closing-protocol
description: >-
  Protocolo de cierre de sesión. Actualiza la memoria persistente del proyecto con lo realizado
  durante la sesión actual, para que un futuro agente conozca el trabajo hecho, las tareas
  completadas y las tareas pendientes. Úsalo al terminar una sesión de trabajo, antes de cerrar,
  o cuando el usuario diga "cierra la sesión", "protocolo de cierre", "closing protocol",
  "guarda el progreso" o similar. Obligatorio actualizar progress.md y tasks.md; los otros cuatro
  archivos (lessons, decisions, assumptions, constrains) se actualizan solo si aplica. Agnóstico:
  funciona en cualquier proyecto que use la capa de persistencia estándar.
---

# Closing Protocol — Protocolo de cierre de sesión

Objetivo: dejar la **memoria persistente** del proyecto al día antes de terminar la sesión, de
forma que cualquier agente futuro (Claude Code, Codex, opencode, Gemini) pueda retomar el trabajo
sabiendo **qué se hizo**, **qué quedó completado** y **qué falta por hacer**.

Este skill es **agnóstico al proyecto**: no asume stack, lenguaje ni estructura particular, solo
la existencia de la capa de persistencia estándar.

---

## Paso 0 — Cargar el contexto y determinar el directorio de memoria

1. **Localizar `project.yaml`** (contexto declarativo del proyecto):
   - `_context/project.yaml` en la raíz del proyecto; si no existe,
   - una carpeta **de la raíz** cuyo nombre **termine en `_context`** (p. ej. una variante con
     prefijo numérico) que contenga `project.yaml`.
2. **Si hay `project.yaml`:** leer `persistence.dir` → ese es el directorio de memoria activo.
   Retener también la sección `repository` (se usa en el Paso 6).
3. **Si no hay `project.yaml`** (respaldo): usar `_persistence/` en la raíz o, si no, una carpeta
   **de la raíz** cuyo nombre **termine en `_persistence`** que contenga `progress.md` y `tasks.md`.
4. Si no se encuentra memoria por ninguna vía, **detener** e informar al usuario: no hay capa de
   persistencia que actualizar.

En adelante, `<MEM>` = el directorio de memoria activo detectado.

---

## Paso 1 — Recopilar lo realizado en la sesión

Antes de escribir, reunir la evidencia de lo que se hizo:

- Repasar la conversación de la sesión actual (objetivos planteados y resultados).
- Si el proyecto usa git: revisar `git status` y `git diff` para ver archivos cambiados.
- Identificar: tareas completadas, decisiones tomadas, problemas resueltos, supuestos nuevos,
  restricciones descubiertas y tareas que quedan pendientes.

---

## Paso 2 — (OBLIGATORIO) Actualizar `progress.md`

En `<MEM>/progress.md`:

1. Añadir una **nueva entrada** al inicio del `## Historial` con el formato del archivo:
   estado, resumen de lo hecho, siguiente paso y referencias.
2. Actualizar la fila correspondiente en la sección **`## Índice`** (crear la fila nueva y, si
   procede, cambiar el estado de entradas previas de "en progreso" a "completado").

---

## Paso 3 — (OBLIGATORIO) Actualizar `tasks.md`

En `<MEM>/tasks.md`:

1. Marcar como completadas `[x]` las tareas terminadas en esta sesión.
2. Mover tareas a "En progreso" `[~]` o "Bloqueadas" `[!]` según corresponda.
3. **Añadir las tareas futuras** detectadas, con un ID nuevo estable (`T-XXX`, sin reutilizar IDs).
4. Actualizar la tabla de la sección **`## Índice`** para reflejar los cambios de estado y las
   tareas nuevas.

---

## Paso 4 — (A DEMANDA) Actualizar los otros cuatro archivos

Actualizar solo si en la sesión ocurrió algo que lo justifique:

| Archivo | Actualizar cuando... |
|---|---|
| `decisions.md` | Se tomó una decisión relevante (arquitectura, enfoque, herramienta). Registrar `D-XXX`. |
| `lessons.md` | Se cometió y resolvió un error, o se descubrió algo no obvio. Registrar `L-XXX`. |
| `assumptions.md` | Se asumió algo sin confirmar, o un supuesto previo se confirmó/refutó. Registrar/actualizar `A-XXX`. |
| `constrains.md` | Apareció una restricción firme y no negociable. Registrar `C-XXX`. |

En cada archivo que se toque, **actualizar también su `## Índice`** en el mismo cambio.

Flujo de promoción entre archivos:
- Supuesto confirmado → promover a `decisions` o `constrains`.
- Supuesto refutado → registrar la corrección en `lessons`.

---

## Paso 5 — Verificar y confirmar

1. Confirmar que **todos** los índices de los archivos tocados quedaron sincronizados (regla de oro:
   ninguna entrada del cuerpo sin su fila en el índice, y viceversa).
2. No reutilizar IDs; mantener las fechas en formato `YYYY-MM-DD`.
3. Presentar al usuario un **resumen breve** de qué archivos se actualizaron y con qué entradas.
4. **Ejecutar la capa de conformidad** si existe (`sh _tools/conformance.sh .`) e incluir su
   **veredicto** en el resumen. Es barata (segundos) y no modifica nada: solo lee artefactos y
   `git log`.
   - **Informar, no bloquear.** Un veredicto `NO CONFORME` **no** detiene el cierre: se reporta al
     humano con sus fallos, que decide. La autoridad es suya (NC-6).
   - Los fallos que revelen un defecto del harness —y no del proyecto en curso— se registran como
     **lección** en el Paso 4, que es lo que convierte el check en aprendizaje.

> **Por qué aquí (L-019).** Los checks de conformidad llevaban tres corridas escritos en los prompts
> **sin que nadie los ejecutara nunca**. Un check que depende de que alguien se acuerde de mirarlo no
> es un control: engancharlo a un paso obligatorio es lo que lo vuelve real.

---

## Paso 6 — (Git) Commit & push

Este paso sincroniza el trabajo de la sesión con el repositorio remoto. Usa la sección
`repository` de `project.yaml` (leída en el Paso 0).

1. **Comprobar repositorio git:** si el proyecto no es un repo git (`git rev-parse` falla),
   **omitir** este paso e informar (no es un error; no todos los proyectos usan git).

2. **Asegurar el remoto (Rol B):** si no hay `origin` configurado y `repository.url` está definido
   en `project.yaml`, configurarlo con `git remote add origin <repository.url>`. `project.yaml` es
   la fuente de verdad de la URL; no hardcodear ninguna URL en este skill.

3. **Commit:** `git add -A` y `git commit` con un mensaje que **resuma la sesión**, siguiendo la
   convención de `_guideline/git-protocol.md` §4 (Apéndice de `methodology.md`):

   ```
   tipo(<alcance>): descripción
   ```

   - **`tipo`** ∈ `feat` · `spec` · `plan` · `test` · `refactor` · `verify` · `chore` · `docs`.
     Elegir el que domine el trabajo de la sesión; si la sesión fue mayormente de memoria y
     documentación, es `docs`.
   - **`<alcance>`** es el incremento en curso; en el estadio de Prototipo, `prototipo`. Si la sesión
     no pertenece a ningún incremento (trabajo transversal del proyecto), omitir el paréntesis.
   - **descripción:** reutilizar el título de la entrada nueva de `progress.md`, recortado a una línea.

   > **Una convención sirve si se puede consultar por ella.** El historial es la traza de §10; con
   > mensajes libres, «¿qué se hizo en el incremento X?» deja de ser una consulta y pasa a ser una
   > lectura completa del log.

4. **Comprobar la rama contra `repository.default_branch`:** si la rama actual **no coincide** con la
   declarada en `project.yaml`, **avisar al humano antes de empujar** y no renombrar nada por cuenta
   propia. Suele significar que el repo se inicializó sin leer `project.yaml` (ver `git-protocol.md`
   §2) o que se trabaja en una rama de incremento. Empujar en silencio una rama distinta de la
   declarada publica el trabajo donde nadie lo espera.

5. **Push (según `repository.auto_push`):**
   - Si `auto_push: true` → `git push` a la rama actual.
   - Si `auto_push: false` o no está definido → **NO** empujar automáticamente. Informar al usuario
     que el commit quedó listo y **pedir confirmación explícita** antes de ejecutar `git push`.

6. **Reportar el resultado:** hash del commit, rama, y si se empujó o quedó pendiente de confirmar.

> Si el `push` falla por credenciales, informar al usuario: la autenticación con GitHub (PAT, SSH o
> `gh auth login`) es configuración del entorno, no de este protocolo.

---

## Reglas invariantes

- **Nunca** escribir fuera del directorio de memoria activo (`<MEM>`) detectado en el Paso 0. Si
  existen otras carpetas `*_persistence` (p. ej. un molde dentro de un entregable), no tocarlas.
- `progress.md` y `tasks.md` son **siempre obligatorios**; los otros cuatro, solo a demanda.
- **El mensaje de commit sigue la convención** de `_guideline/git-protocol.md` §4; el `push` es lo
  único que depende de `repository.auto_push`, el commit no.
- Idioma de la memoria: el del proyecto (por defecto, español).
- No inventar trabajo: registrar únicamente lo que realmente ocurrió en la sesión.
