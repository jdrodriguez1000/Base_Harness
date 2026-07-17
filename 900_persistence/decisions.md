# Decisions (ADR ligero)

> Registro de decisiones importantes (Architecture Decision Records simplificados).
> Una decisión aquí es vinculante hasta que otra decisión posterior la reemplace explícitamente.

## Índice

> Mantener sincronizado: al registrar o cambiar el estado de una decisión, actualizar su fila aquí.
> Buscar por ID (`D-XXX`) para localizar la decisión sin leer todo el archivo.

| ID | Decisión | Estado | Fecha |
|---|---|---|---|
| D-001 | Adoptar una capa de persistencia en `_persistence/` | aceptada | 2026-07-17 |
| D-002 | Separar la plantilla (`_persistence/`) de la memoria de este proyecto (`900_persistence/`) | aceptada | 2026-07-17 |
| D-003 | Añadir `_context/project.yaml` como contexto declarativo; su sección `repository` es la fuente de verdad de la URL del repo (Rol B) | aceptada | 2026-07-17 |

## Formato

```
### D-001 — <título de la decisión>
- **Estado:** propuesta | aceptada | reemplazada por D-XXX
- **Fecha:** YYYY-MM-DD
- **Contexto:** qué situación obliga a decidir.
- **Decisión:** qué se decidió.
- **Alternativas consideradas:** opciones descartadas y por qué.
- **Consecuencias:** implicaciones (positivas y negativas).
```

---

## Registro

### D-001 — Adoptar una capa de persistencia en `_persistence/`
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** El harness debe conservar memoria entre sesiones y entre distintos agentes (Claude Code, Codex, opencode, Gemini).
- **Decisión:** Centralizar el estado del proyecto en archivos Markdown dentro de `_persistence/`.
- **Alternativas consideradas:** Base de datos o herramienta externa (descartada por acoplar el harness a infraestructura y romper la portabilidad).
- **Consecuencias:** Persistencia legible por humanos y por cualquier agente, versionable en git; requiere disciplina de actualización manual.

### D-002 — Separar la plantilla (`_persistence/`) de la memoria de este proyecto (`900_persistence/`)
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** En este proyecto el entregable ES la carpeta `_persistence/` (el molde reutilizable). Si registráramos aquí la memoria real de su construcción, contaminaríamos la plantilla que heredarán otros proyectos.
- **Decisión:** La memoria real de ESTE proyecto vive en `900_persistence/`. La carpeta `_persistence/` se conserva como plantilla limpia y genérica. En proyectos futuros no existe `900_persistence/`: esos proyectos usan `_persistence/` directamente como su memoria de trabajo, porque ahí `_persistence/` ya no es un entregable sino una herramienta.
- **Alternativas consideradas:** (a) Usar `_persistence/` también en este proyecto (descartada: mezcla molde y contenido). (b) Duplicar manualmente sin convención (descartada: sin trazabilidad).
- **Consecuencias:** Doble carpeta solo durante la construcción del harness; regla clara de "molde vs. instancia"; requiere mantener `_persistence/` libre de datos específicos de este proyecto.

### D-003 — Añadir `_context/project.yaml` como contexto declarativo; Rol B: fuente de verdad de la URL del repo
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** Los protocolos de inicio/cierre y el Paso 6 (commit & push) del `closing-protocol` necesitaban conocer, sin hardcodear, dónde vive la memoria (`persistence.dir`) y los metadatos del repositorio (URL, rama, política de `auto_push`) para mantener los skills y agentes agnósticos.
- **Decisión:** Crear `_context/project.yaml` (molde en `template/_context/`, real en `905_context/`) como fuente única de verdad declarativa del proyecto. Su sección `repository` (Rol B) resuelve la URL del remoto para el commit & push automático, evitando URLs hardcodeadas en skills/agentes.
- **Alternativas consideradas:** Hardcodear la URL del repo en el skill `closing-protocol` (descartada: rompe la agnosticidad y obliga a editar el skill por proyecto). Detectar el remoto solo por convención de carpeta sin yaml (descartada: no permite declarar `auto_push` ni otros metadatos).
- **Consecuencias:** El Paso 0 de ambos protocolos y el Paso 6 del `closing-protocol` dependen de `project.yaml` cuando existe, con respaldo por convención de nombre si no existe; requiere mantener `project.yaml` actualizado si cambia el remoto o la política de push.

