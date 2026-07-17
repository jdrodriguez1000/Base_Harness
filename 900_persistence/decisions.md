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
| D-004 | `register-harness` como mecanismo oficial de portabilidad/sincronización; fuente única de verdad = `.claude/`; arquitectura de dos niveles | aceptada | 2026-07-17 |
| D-005 | Resolver la bootstrap-paradoja con doble frente: espejo del procedimiento en `AGENTS.md` + autoprovisión de `register-harness` en el destino | aceptada | 2026-07-17 |
| D-006 | Los protocolos de inicio/cierre se ejecutan SIEMPRE delegando en su agente especializado, no directamente desde la sesión principal | aceptada | 2026-07-17 |
| D-007 | `principles.md` como comportamiento canónico vinculante, referenciado por convención (`_guideline/`), no por ruta fija | aceptada | 2026-07-17 |
| D-008 | `methodology.md` agnóstico con dos ejes (madurez/incremento) y arquetipos de agente en vez de flota concreta | aceptada | 2026-07-17 |
| D-009 | Distinción deseabilidad/factibilidad como forma de trabajo del estadio Prototipo, con frontera dura Prototipo→MVP | aceptada | 2026-07-17 |
| D-010 | Un solo prototipado al inicio del proyecto; se elimina "Prototipar" como fase repetida por incremento | aceptada | 2026-07-17 |
| D-011 | *Revisor de código* como arquetipo evaluador independiente del Verificador, adoptado bajo E4 | aceptada | 2026-07-17 |
| D-012 | Especialización de flota (p. ej. frontend/backend) es decisión de instanciación, no de arquetipo, bajo E4 | aceptada | 2026-07-17 |
| D-013 | Regla de diseño de `AGENTS.md`: marco mínimo + punteros, sin duplicar procedimientos que ya viven en los `SKILL.md` | aceptada | 2026-07-17 |

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

### D-004 — `register-harness` como mecanismo oficial de portabilidad/sincronización
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** El harness debe poder usarse desde distintas herramientas de agente (Claude Code, Codex, opencode, Gemini), cada una con su propio formato y ubicación de skills/agentes. Mantener sincronizadas a mano varias copias (p. ej. `.claude/` vs `template/.claude/`, o futuras `.opencode/`) es frágil y no escala (era el problema que registraba `T-002`). Se verificó con documentación oficial (vía ctx7) que Codex usa `.agents/skills/<n>/SKILL.md` (formato compatible) y `~/.codex/agents/*.toml`, y que opencode usa `.opencode/skills/<n>/SKILL.md` (formato compatible) y `.opencode/agents/*.md` (frontmatter propio); ambos leen `AGENTS.md`.
- **Decisión:** Adoptar `register-harness` como el mecanismo oficial de portabilidad y sincronización del harness. `.claude/` es la **fuente única de verdad**. Arquitectura de dos niveles: **Nivel 1** — `AGENTS.md` con los protocolos escritos en línea (texto plano, universal, no depende del formato de ninguna herramienta); **Nivel 2** — skills y agentes nativos por herramienta (`.claude/`, `.opencode/`, `.agents/`, etc.), generados/auditados a partir de la fuente. Esta decisión absorbe y reemplaza la tarea manual `T-002` de sincronizar copias de `.claude/`.
- **Alternativas consideradas:** (a) Seguir sincronizando copias a mano por convención sin skill dedicado (descartada: no escala a 4 herramientas y sin trazabilidad de qué falta). (b) Un único formato "universal" de skill que todas las herramientas leyeran directamente (descartada: cada herramienta ya tiene su propio formato y ubicación fijados por su propia documentación, no controlable desde este proyecto).
- **Consecuencias:** `register-harness` empieza en modo solo-auditoría (informa qué falta, no escribe); queda pendiente una fase de PROVISIÓN que sí genere los artefactos faltantes para cada herramienta (`T-008`), así como resolver la bootstrap-paradoja de poder invocar el propio `register-harness` desde dentro de una herramienta distinta a Claude Code (`T-009`), y extender el soporte a Codex y Gemini (`T-010`, `T-011`).

### D-005 — Resolver la bootstrap-paradoja con doble frente (espejo en `AGENTS.md` + autoprovisión)
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** `register-harness` vive como skill de Claude Code. Si un agente está en otra herramienta (p. ej. opencode) y el harness aún no se ha provisionado ahí, no tiene el skill nativo para arrancar la portabilidad ni para re-sincronizar tras editar la fuente. Es la "bootstrap-paradoja": para portar el harness hace falta una pieza que solo existe en la herramienta base.
- **Decisión:** Resolverla con **dos frentes complementarios**. **(b) Espejo en `AGENTS.md`:** añadir la sección *Portabilidad del harness* con el procedimiento resumido (auditar/provisionar, ubicaciones destino, traducción de frontmatter, modelos), que apunta al detalle canónico en `.claude/skills/register-harness/SKILL.md`. Como **todas** las herramientas leen `AGENTS.md`, cualquier agente puede portar el harness aunque parta de cero. **(a) Autoprovisión:** la fase de provisión copia el propio `register-harness` a `.opencode/skills/register-harness/SKILL.md`, dejando a la herramienta destino **autosuficiente** para re-auditar/re-sincronizar sin depender de Claude Code. Fundamento común: la fuente de verdad son **archivos de texto** (`.claude/…`) que cualquier herramienta lee con sus tools de archivo; no es una capacidad exclusiva de Claude.
- **Alternativas consideradas:** (a solo) copiar `register-harness` al destino sin espejo en `AGENTS.md` (descartada: no resuelve el arranque *inicial*, cuando aún no hay nada provisionado). (b solo) espejar únicamente en `AGENTS.md` sin autoprovisión (descartada: obliga a re-sincronizar siempre "a mano" siguiendo el texto, sin skill nativo). Mantener una sola copia del procedimiento (descartada: el bootstrap exige que el arranque no dependa de `.claude/`).
- **Consecuencias:** El procedimiento de portabilidad queda **duplicado** en dos sitios (skill `register-harness` + sección de `AGENTS.md`) que hay que mantener **alineados** al cambiarlo (ver [[lessons]] L-001 sobre riesgo de desincronización). Por ahora resuelto solo para **opencode**; Codex y Gemini replicarán el patrón (`T-010`/`T-011`). La regla operativa: editar la fuente `.claude/` y re-sincronizar (modo re-sync, que sobrescribe); nunca editar el reflejo del destino.

### D-006 — Los protocolos de inicio/cierre se ejecutan SIEMPRE delegando en su agente especializado
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** Hasta ahora el `CLAUDE.md` de la raíz permitía ejecutar los protocolos de inicio/cierre invocando directamente su skill (`startup-protocol`/`closing-protocol`) **o** delegando en su agente (`sesion-starter`/`sesion-closer`). El usuario dio feedback explícito de que quiere que la sesión principal delegue siempre en el agente, no que ejecute el skill por su cuenta.
- **Decisión:** El `CLAUDE.md` de la raíz (secciones "Inicio de sesión" y "Cierre de sesión") se actualiza para hacer obligatorio invocar el agente especializado: inicio → agente `sesion-starter`; cierre → agente `sesion-closer`. La sesión principal no debe ejecutar el skill directamente.
- **Alternativas consideradas:** Mantener ambas vías como equivalentes (skill directo o agente) — descartada porque el usuario prefiere una única vía consistente y auditable a través del agente dedicado.
- **Consecuencias:** Mayor consistencia y trazabilidad (el agente aplica el protocolo de forma aislada y reporta un resumen); pequeño costo adicional de indirección (una invocación de agente en vez de un skill directo). Ver también [[constrains]] C-002.

### D-007 — `principles.md` como comportamiento canónico vinculante, referenciado por convención
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** `template/_guideline/principles.md` (P1–P8, E1–E13, NC-1…NC-6) existía pero ningún archivo de instrucciones (agentes de sesión, `AGENTS.md`, `CLAUDE.md`, `register-harness`) lo señalaba explícitamente como comportamiento obligatorio. Se auditó y se confirmó que el archivo en sí es totalmente agnóstico (sin referencias a dominio, lenguaje ni stack), por lo que no necesitaba cambios propios.
- **Decisión:** Cablear `principles.md` como fuente canónica de comportamiento **vinculante** en los puntos de entrada de cualquier agente: `template/AGENTS.md` (sección "Principios de comportamiento (VINCULANTE)"), `CLAUDE.md` de la raíz, los agentes `sesion-starter`/`sesion-closer` (bullet "Comportamiento vinculante", énfasis en NC-1/NC-6) y `register-harness` (se añade a la fuente única de verdad/baseline que se propaga a opencode/Gemini). La referencia se hace por **convención de carpeta** (`_guideline/`), igual que la persistencia (`_persistence/`), no por ruta fija hardcodeada.
- **Alternativas consideradas:** Hardcodear la ruta exacta `template/_guideline/principles.md` en cada agente (descartada: rompe la agnosticidad si un proyecto futuro reubica el guideline). Crear una carpeta de instancia `905_guideline/` análoga a `905_context/`/`900_persistence/` (descartada por ahora: fuera de alcance de esta sesión, `principles.md` no tiene contenido específico de este proyecto que separar de un molde).
- **Consecuencias:** Cualquier agente que arranque leyendo `AGENTS.md`/`CLAUDE.md` o se delegue a `sesion-starter`/`sesion-closer` queda obligado a cumplir P1–P8/E1–E13/NC-1…NC-6 como comportamiento prevalente e inmutable. Pendiente evaluar si en el futuro se necesita una carpeta de instancia para el guideline.

### D-008 — `methodology.md` agnóstico con dos ejes y arquetipos de agente
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** El molde `template/_guideline/` tenía una versión de `methodology.md` acoplada al proyecto ZeroLeak (referencia, no genérica), lo que violaba el requisito fundacional de agnosticidad del harness (ver `CLAUDE.md`).
- **Decisión:** Reemplazar `methodology.md` por una versión totalmente agnóstica que cubre dos tipos de proyecto (Software y Ciencia de datos/ML) con una espina común, dos ejes independientes (MADUREZ: Prototipo→MVP→Evolucionado; INCREMENTO: slices verticales), un ciclo de vida de 13 pasos con gates humanos, gates de calidad, capa de persistencia, evaluación dimensionada, evolución (E4) y observabilidad (E13). Los agentes se describen a nivel de **arquetipo** (constructores de ENTREGABLES vs constructores de CÓDIGO), no como una flota concreta de agentes nombrados.
- **Alternativas consideradas:** Mantener `methodology.md` como documento de referencia específico de ZeroLeak fuera del molde (descartada: el molde debe ser agnóstico de punta a punta). Definir una flota de agentes concreta y nombrada en la metodología (descartada: acoplaría el molde a una implementación particular; se prefiere el nivel de arquetipo, más portable).
- **Consecuencias:** El molde queda coherente con el requisito de agnosticidad. La estructura física de carpetas para artefactos por incremento y una posible `_template/` de entregables queda **pendiente de instanciación** (no se inventó numeración de carpetas en esta sesión). Trabajo de continuación previsto en `T-016`.

### D-009 — Distinción deseabilidad/factibilidad en el estadio Prototipo, con frontera dura Prototipo→MVP
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** A partir de un archivo temporal (`temp.md`, no versionado, provisto por el usuario y que será borrado) se identificó una distinción agnóstica valiosa dentro del estadio "Prototipo" de `methodology.md`, que antes era un único concepto indiferenciado.
- **Decisión:** Reescribir la §4 (Estadios de madurez) de `methodology.md` en subsecciones 4.1–4.5, distinguiendo dos tipos de prototipo — de **deseabilidad** (actividad humana, de diseño, sin agentes) y de **factibilidad** (desde aquí participan agentes) — y estableciendo una disciplina de alcance del prototipo (timebox + feature freeze, camino feliz, roles/actores priorizados, split prototyping, gatekeeper cuantitativo, exclusiones explícitas). Se define una **frontera dura** entre Prototipo y MVP: el MVP es el primer entregable **funcional** (Tracer Bullet), cualitativamente distinto del prototipo.
- **Alternativas consideradas:** Mantener "Prototipo" como una única etapa sin distinguir deseabilidad de factibilidad (descartada: perdía la frontera humano↔agente, relevante para saber cuándo delegar en agentes). Fusionar prototipo y MVP en una sola etapa continua (descartada: el usuario identificó que la frontera es cualitativa —funcional vs no funcional— y debe quedar explícita).
- **Consecuencias:** `methodology.md` ahora comunica claramente cuándo el trabajo es humano (deseabilidad) y cuándo pueden intervenir agentes (desde factibilidad en adelante), y evita que un "prototipo" se confunda con un MVP. El archivo temporal `temp.md` no se versiona como fuente; su contenido ya quedó absorbido en `methodology.md`.

### D-010 — Un solo prototipado al inicio del proyecto; se elimina "Prototipar" como fase repetida por incremento
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** `methodology.md` usaba el término "Prototipar" en dos sentidos distintos y confusos: como estadio de madurez inicial (§4) y como paso repetido dentro del ciclo de cada incremento/vertical slice (§3). Esto sugería erróneamente que cada slice vertical era un "prototipo", cuando en realidad las slices son funcionalidad real posterior al MVP.
- **Decisión:** El prototipo pasa a ser **un único estadio de alto nivel** al comienzo del proyecto (ver D-009), no una fase que se repite en cada incremento. La espina común (§2) se simplifica a `Definir → Especificar → Planear → Construir → Verificar → Integrar`; el ciclo de incremento (§3) pasa de 13 a 11 pasos. Se añade una nota de excepción para *spikes* (prototipado técnico puntual y opcional dentro de un incremento, distinto del estadio Prototipo).
- **Alternativas consideradas:** Mantener "Prototipar" en ambos sentidos aclarando con texto la diferencia (descartada: ambigüedad de vocabulario persistente, alto riesgo de confusión futura). Eliminar el estadio Prototipo inicial y dejar solo el prototipado por incremento (descartada: contradice D-009, que fija el prototipo de deseabilidad/factibilidad como frontera humano↔agente al inicio).
- **Consecuencias:** Vocabulario más limpio: "prototipo" = estadio inicial; "vertical slice" = incremento de funcionalidad real. §5 reubica al *Prototipador* en el estadio inicial. §6 ajusta sus gates al nuevo ciclo de 11 pasos. Los *spikes* quedan documentados como mecanismo de excepción opcional, no como parte del flujo estándar.

### D-011 — *Revisor de código* como arquetipo evaluador independiente del Verificador
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** `methodology.md` ya definía un juez LLM de calidad para entregables (§8.1) y un Verificador para código, pero no existía un arquetipo evaluador análogo al juez LLM aplicado específicamente al código (revisión de calidad/estilo/mantenibilidad, más allá de que los tests pasen).
- **Decisión:** Añadir el arquetipo *Revisor de código* (§5.2) como evaluador independiente, distinto del Verificador (que valida conformidad funcional/tests). Su adopción se rige por E4 (evolución incremental de la flota), no es obligatorio desde el día uno.
- **Alternativas consideradas:** Fusionar la revisión de código dentro del rol del Verificador (descartada: mezcla dos evaluaciones de naturaleza distinta —conformidad determinista vs juicio de calidad— igual que se separaron para entregables en §8.1/§10.1). No definir el arquetipo y dejarlo implícito (descartada: rompe la simetría con el patrón ya establecido para entregables).
- **Consecuencias:** La metodología ahora tiene un patrón evaluador simétrico para entregables (juez LLM, §8.1/§10.1) y para código (Revisor de código, §5.2), ambos adoptables de forma incremental bajo E4.

### D-012 — Especialización de flota (frontend/backend) es decisión de instanciación, no de arquetipo
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** Surgió la pregunta de si la metodología agnóstica debía definir arquetipos separados para frontend y backend, lo cual acoplaría el molde a un stack/dominio concreto (violando el requisito fundacional de agnosticidad, ver `CLAUDE.md`).
- **Decisión:** La especialización de la flota (p. ej. dividir un arquetipo constructor en variantes frontend/backend) es una **decisión de instanciación** de cada proyecto concreto, tomada bajo E4 (evolución incremental), no una definición fija en el molde agnóstico.
- **Alternativas consideradas:** Definir arquetipos frontend/backend explícitos en `methodology.md` (descartada: acopla el molde a proyectos con esa topología, excluyendo p. ej. proyectos de ciencia de datos/ML o CLI puros).
- **Consecuencias:** `methodology.md` permanece agnóstica al stack; cada proyecto instanciado decide su propia especialización de flota como parte de su evolución (E4), documentándola en su propia memoria (`decisions.md` de la instancia).

### D-013 — Regla de diseño de `AGENTS.md`: marco mínimo + punteros, sin duplicar procedimientos
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** `template/AGENTS.md` había crecido a 273 líneas, duplicando contenido (protocolos de inicio/cierre completos, tablas de portabilidad a opencode/Gemini) que ya vivía de forma canónica en los `SKILL.md` correspondientes (ver D-005 y su riesgo de desincronización documentado en `lessons` L-001). Mantener dos copias del mismo procedimiento es frágil.
- **Decisión:** `AGENTS.md` se simplifica a un marco mínimo (101 líneas) que **apunta** a la fuente canónica de cada procedimiento en vez de duplicarlo íntegro. Se añade una "Regla de diseño" explícita en el header del archivo: no duplicar procedimientos, solo referenciarlos.
- **Alternativas consideradas:** Mantener el contenido íntegro en `AGENTS.md` por ser el único archivo que todas las herramientas leen de forma garantizada (descartada: el costo de sincronización manual supera el beneficio, y el patrón de puntero ya funciona para otros casos en el harness). Eliminar el espejo de portabilidad de `AGENTS.md` por completo (descartada: seguiría haciendo falta un punto de entrada mínimo para la bootstrap-paradoja, ver D-005; se resuelve con un puntero corto, no con el contenido completo).
- **Consecuencias:** `AGENTS.md` queda más mantenible y con menor riesgo de desincronización; el detalle procedimental vive en un único lugar (los `SKILL.md`). Requiere disciplina: al crear nuevos procedimientos, seguir el patrón de puntero en vez de volver a duplicar contenido en `AGENTS.md`.

