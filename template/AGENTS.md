# AGENTS.md

> **Fuente única de verdad** de las instrucciones de este proyecto para agentes de IA.
> Válido para Claude Code, Codex, opencode y Gemini. Los archivos `CLAUDE.md` y `GEMINI.md`
> son punteros a este archivo: si los lees, ven aquí y sigue estas instrucciones.
>
> Este archivo es **agnóstico**: no asume lenguaje, stack ni framework. Complétalo con lo
> específico de tu proyecto en la sección *Contexto del proyecto*.

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
