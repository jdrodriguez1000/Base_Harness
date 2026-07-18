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
| D-014 | `state.yaml` estructurado (no Markdown narrativo) como estado por-incremento | aceptada | 2026-07-17 |
| D-015 | Orquestador como escritor único (Single Writer) de `state.yaml` | aceptada | 2026-07-17 |
| D-016 | Espina única de 11 pasos en `state.yaml`: capas técnicas como tareas etiquetadas, revisiones transversales como entradas de evaluación en Verificar | aceptada | 2026-07-17 |
| D-017 | `security-reviewer` como arquetipo evaluador transversal hermano del Revisor de código | aceptada | 2026-07-17 |
| D-018 | Modelo de gate único y reutilizable (`status`/`fecha`/`resoluciones`) aplicable a los pasos 5, 7 y 11 de `state.yaml`, con plantilla física `_templates/state_temp.yaml` | aceptada | 2026-07-17 |
| D-019 | Referencia a `methodology.md` cableada en `AGENTS.md` (SSOT), no en `CLAUDE.md` | aceptada | 2026-07-17 |
| D-020 | Taxonomía de actores por defecto (GENERADOR→OPERADOR→ADMINISTRADOR) y arquetipo Descubridor como insumo del Prototipador, orden Descubridor→Prototipador | aceptada | 2026-07-17 |
| D-021 | El arquetipo Descubridor se materializa como dos agentes (`onboarding-interviewer` + `onboarding-writer`), separando elicitar de estructurar; log append-only reanudable; writer subagente autónomo | aceptada | 2026-07-17 |
| D-022 | Los arquetipos de construcción del prototipado (Descubridor y futuros) viven solo en `template/.claude`, no en la raíz `.claude/` (son deliverable-only) | aceptada | 2026-07-17 |
| D-023 | Perfiles de conformidad (§10) escritos en cada agente del Descubridor + oráculo de trazabilidad log→discovery + política de evaluación del interviewer (cobertura + gate humano); construcción del motor diferida por E4 | aceptada | 2026-07-17 |
| D-024 | `interview_document.md` se conserva como traza junto a `discovery.md` tras la síntesis (promovida de `A-002`, confirmada por el usuario) | aceptada | 2026-07-17 |

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

### D-014 — `state.yaml` estructurado como estado por-incremento
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** §7 de `methodology.md` mencionaba "estado del incremento" sin definir su formato. A partir de una muestra `state.json` del flujo previo del usuario (`temp.md`) se identificó la necesidad de fijar el formato del estado por-incremento, distinto de la persistencia narrativa de `_persistence/`.
- **Decisión:** El estado por incremento se modela como archivo **estructurado** por convención `state.yaml` (YAML), no como Markdown narrativo. Es la máquina de estado del ciclo de vida (§3) de la vertical slice: la consumen el orquestador (para reanudar) y los checks de conformidad (§10, para auditar), no un lector humano en primera instancia.
- **Alternativas consideradas:** Reutilizar el patrón narrativo de `_persistence/` (Markdown con `## Índice`) también para el estado por incremento (descartada: mezcla dos naturalezas distintas — bitácora humana vs máquina de estado consumida programáticamente — y dificulta el parseo determinista para los checks de conformidad).
- **Consecuencias:** `methodology.md` distingue explícitamente dos capas de persistencia con formatos distintos (§7). La ruta física exacta de `state.yaml` queda pendiente de instanciación (relacionado con T-018, estructura de `_increments/<id>/`).

### D-015 — Orquestador como escritor único (Single Writer) de `state.yaml`
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** Si varios agentes de la flota escribieran directamente el estado de la slice, se generarían condiciones de carrera y un estado no confiable para la reanudación.
- **Decisión:** El **orquestador** (sesión principal) es el **único** responsable de escribir `state.yaml`. Cada **artefacto** (`definition`, `spec`, `plan`, código, tests) lo escribe solo su agente productor; los subagentes reportan resultados y el orquestador verifica y transcribe al `state.yaml`.
- **Alternativas consideradas:** Que cada agente/etapa escriba directamente su sección del `state.yaml` (descartada: multiplica escritores concurrentes sobre un mismo archivo, rompiendo la Single Writer Rule ya adoptada para la persistencia narrativa en §7).
- **Consecuencias:** Consistencia garantizada del estado; el orquestador se vuelve el punto único de verdad y de fallo para la reanudación de una slice interrumpida.

### D-016 — Espina única de 11 pasos en `state.yaml`
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** Al modelar el `state.yaml` surgió la tentación de bifurcar el ciclo de vida por capa técnica (frontend/backend/DB) o por tipo de revisión (código/seguridad), lo que habría multiplicado la máquina de estado y roto la coherencia con la espina común de 11 pasos ya fijada en D-010.
- **Decisión:** `state.yaml` modela **un solo** ciclo §3 (Definir → … → Integrar) por slice. Las capas técnicas **no son pasos**: son *tareas etiquetadas* (`component` + `owner`) dentro de Construir (paso 8). Las revisiones transversales (calidad de código §5.2, seguridad) son **entradas de evaluación** dentro de Verificar (paso 10), no pasos nuevos. Si algo es valor end-to-end independiente de otra funcionalidad, es **otra slice** (otro `state.yaml`), no una rama de la actual.
- **Alternativas consideradas:** Bifurcar el ciclo por capa técnica (paso "Construir-FE", "Construir-BE", "Construir-DB" separados) — descartada: contradice NC-4 (una slice es end-to-end) y multiplica la máquina de estado sin necesidad. Añadir pasos nuevos para revisión de código/seguridad — descartada: ya existe el paso Verificar (10) como punto de entrada de evaluación; añadir pasos rompería la espina única de D-010.
- **Consecuencias:** El `state.yaml` permanece simple y uniforme entre slices, independientemente de cuántas capas técnicas o revisores transversales participen. Queda pendiente modelar el detalle de gates con resoluciones y los casos TDD dentro de Construir (T-017 continúa).

### D-017 — `security-reviewer` como arquetipo evaluador transversal hermano del Revisor de código
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** D-011 definió el *Revisor de código* como evaluador independiente del Verificador. Faltaba resolver dónde encaja la revisión de seguridad, que es conceptualmente análoga pero de un dominio distinto.
- **Decisión:** `security-reviewer` es un arquetipo evaluador transversal **hermano** del Revisor de código (§5.2): mismas reglas (independiente, contexto fresco, hallazgos → tests que fallan), adoptable por E4. Se distingue explícitamente la **seguridad-revisión** (auditoría de vulnerabilidades, rol de `security-reviewer`) de la **seguridad-comportamiento** (autorización, validación de input), que **no** es revisión sino un **criterio de aceptación** en la spec (§3, paso 4).
- **Alternativas consideradas:** Fusionar seguridad dentro del Revisor de código genérico sin arquetipo propio (descartada: la revisión de seguridad puede requerir un perfil/contexto distinto al de calidad de código general, aunque puede ser el mismo agente con otro perfil). Tratar toda la seguridad como criterio de aceptación sin evaluador transversal (descartada: pierde la capacidad de detectar vulnerabilidades no cubiertas por specs explícitas).
- **Consecuencias:** El patrón evaluador transversal (§5.2) queda simétrico y extensible: Revisor de código y `security-reviewer` comparten reglas de adopción bajo E4; en `state.yaml` (§7.1) ambos aparecen como entradas de evaluación en Verificar (`code_review`, `security_review`).

### D-018 — Modelo de gate único y reutilizable en `state.yaml`, con plantilla física
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** T-017 dejó pendiente modelar el detalle de los gates (pasos 5, 7 y 11 de la espina D-016) y los casos TDD dentro de Construir. Existía una muestra `state.json` del flujo previo del usuario (`temp.md`, no versionada como fuente) con `gate_paso_5/7/9` como campos separados y redundantes.
- **Decisión:** Modelar un **único esquema de gate** (`status: PENDIENTE|APROBADO|APROBADO_CON_CAMBIOS|RECHAZADO`, `fecha`, `resoluciones: [{punto, decision, contra}]`) reutilizable en los tres pasos que llevan gate (5, 7 y 11), en vez de un campo distinto por paso. Los casos TDD del paso 8 (Construir) se modelan como lista `cases` con `id`, `ca` (criterios de aceptación), `component`, `owner`, `stage` (`pending|red|green|refactor|done`) y `caracterizacion` (bool, test que nace verde). Se creó la plantilla física `template/_templates/state_temp.yaml` como forma instanciable (no caso real), y se enriqueció `§7.1` de `methodology.md` con el árbol de `_increments/<id>/`.
- **Alternativas consideradas:** Mantener un campo de gate distinto por cada paso (`gate_paso_5`, `gate_paso_7`, `gate_paso_11`) como en la muestra original (descartada: duplica esquema sin necesidad, ya que la forma es idéntica en los tres casos). Modelar los casos TDD sin `caracterizacion` (descartada: pierde la distinción entre test que dirige código nuevo —RED antes de GREEN— y test que documenta conducta ya existente, relevante para la observabilidad del ciclo TDD ya fijada en D-014/§3.1).
- **Consecuencias:** El esquema de `state.yaml` queda completo en su forma mínima; cualquier incremento nuevo copia `state_temp.yaml` y lo rellena. Las `resoluciones` de cada gate quedan como la traza más valiosa de qué se decidió y contra qué alternativa.

### D-019 — Referencia a `methodology.md` cableada en `AGENTS.md`, no en `CLAUDE.md`
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** Se detectó que `template/AGENTS.md` solo tenía cableada la referencia a `principles.md` (D-007) pero no a `methodology.md`, dejando la metodología "huérfana": ningún proyecto instanciado desde el molde sabía que ese archivo existía ni que debía consultarlo.
- **Decisión:** Añadir a `template/AGENTS.md` una sección "Metodología de construcción", hermana de la sección de `principles.md`, que apunta a `_guideline/methodology.md`. La referencia va en `AGENTS.md` porque es la fuente única de verdad (SSOT) que todas las herramientas leen; **no** se duplica en `CLAUDE.md` de la raíz, para no romper la regla de diseño ya fijada en D-013 (marco mínimo + punteros, sin duplicar procedimientos).
- **Alternativas consideradas:** Añadir también la referencia en `CLAUDE.md` de la raíz igual que se hizo con `principles.md` en D-007 (descartada: `principles.md` es comportamiento vinculante que debe ser visible incluso desde el punto de entrada específico de Claude Code, mientras que `methodology.md` es contenido de proceso que ya vive completo en el SSOT `AGENTS.md`, al que `CLAUDE.md` apunta).
- **Consecuencias:** Cualquier agente que lea `AGENTS.md` (o se delegue a un agente que lo lea) conoce ahora la existencia de `methodology.md` desde el arranque. `CLAUDE.md` permanece como puntero mínimo sin crecer.

### D-020 — Taxonomía de actores por defecto y arquetipo Descubridor, orden Descubridor→Prototipador
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** Se inició la Parte 1 (método) de un plan de prototipado acordado en 3 partes. Faltaba una lente agnóstica para elicitar actores durante el descubrimiento, y un arquetipo que condujera esa elicitación con el humano antes de que el Prototipador (D-009, estadio Prototipo) empezara a construir.
- **Decisión:** `§4.3` de `methodology.md` fija una taxonomía de actores **por defecto** GENERADOR → OPERADOR → ADMINISTRADOR como lente de elicitación (piso, no techo): los roles pueden faltar o colapsar en un mismo actor; la prioridad **no** es lineal (el generador es obligatorio para arrancar cualquier prototipo; operador/administrador se elicitan bajo demanda); el generador solo basta para avanzar un MVP, simulando el resto con mago de Oz (E4). `§5` añade el arquetipo **Descubridor**: conduce la entrevista con el humano con alcance acotado (para evitar parálisis de análisis), produce un entregable de descubrimiento propio con su Gatekeeper, observable y evaluable, que es insumo directo del Prototipador. Orden fijado: Descubridor → Prototipador. `§4.2` se ajustó para aclarar que el descubrimiento lo conduce un agente (el Descubridor), mientras que la materialización de mockups sigue siendo actividad humana.
- **Alternativas consideradas:** Dejar la elicitación de actores implícita, a criterio de cada instanciación (descartada: sin una lente por defecto, cada proyecto reinventa su propia taxonomía, perdiendo portabilidad del método). Fusionar Descubridor y Prototipador en un solo arquetipo (descartada: mezclaría la naturaleza de "conducir entrevista con el humano" con la de "construir el camino feliz", dos actividades de forma distinta, igual que ya se separaron Definidor/Especificador/Planificador en la espina general).
- **Consecuencias:** El método de prototipado (Parte 1) queda canonizado en `methodology.md`. Queda pendiente la Parte 2 (construir los agentes+skills `descubridor` y `prototipador`, empezando por fijar los campos del entregable de descubrimiento) y la Parte 3 (perfil de conformidad + rúbrica por agente, motor genérico), ver T-021.

### D-021 — El arquetipo Descubridor se materializa como dos agentes (interviewer + writer)
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** D-020 definió el arquetipo Descubridor como quien conduce la entrevista con el humano y produce el entregable de descubrimiento. Al construirlo (Parte 2) surgió una tensión: un subagente no dialoga turno-a-turno con el humano (su insumo es un archivo, no un chat interactivo), pero la entrevista sí necesita ser un diálogo vivo. Además, el usuario preguntó qué pasa si la entrevista se suspende a mitad de camino.
- **Decisión:** El arquetipo Descubridor se materializa como **dos agentes** que separan elicitar de estructurar: **(1) `onboarding-interviewer`** (+ skill `interview-protocol`) conduce SOLO la entrevista con el humano; hace una pregunta y guarda de inmediato la Q&A en `interview_document.md` (**append-only**), lo que hace la entrevista **reanudable** — el log parcial es el estado si se suspende. No interpreta ni estructura nada. **(2) `onboarding-writer`** (+ skill `discovery-protocol`) es un **subagente autónomo** (insumo = archivo `interview_document.md`, no diálogo) que sintetiza el log en el `discovery.md` estructurado: clasifica actores (taxonomía D-020), extrae camino feliz, fija Gatekeeper, declara exclusiones.
- **Alternativas consideradas:** Un solo agente Descubridor que entreviste y estructure a la vez (descartada: mezcla dos actividades de forma distinta — diálogo interactivo vs síntesis autónoma — igual que ya se separaron otros pares en la metodología; además complica la reanudación, porque el estado de "qué se ha preguntado" y "qué se ha estructurado" quedarían acoplados). Que el propio `interview_document.md` sea el entregable final sin estructurar (descartada: pierde la clasificación explícita de actores/Gatekeeper/exclusiones que el Prototipador necesita como insumo directo).
- **Consecuencias:** La entrevista queda protegida ante interrupciones (append-only = reanudable sin pérdida). El writer puede ejecutarse en cualquier momento posterior, incluso en otra sesión, con solo el archivo de log como insumo. Se añadió la plantilla `template/_templates/interview_temp.md` (log crudo) junto a `discovery_temp.md` (entregable estructurado). Queda abierta la consideración de si `interview_document.md` se conserva como traza tras la síntesis o se descarta (ver [[assumptions]] A-002).

### D-022 — Arquetipos de construcción del prototipado solo en `template/.claude`, no en la raíz
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** Al construir `onboarding-interviewer`/`onboarding-writer` surgió la duda de si estos agentes debían replicarse también en la raíz `.claude/` de este repo, siguiendo el patrón ya usado para `sesion-starter`/`sesion-closer`/`register-harness` (que sí viven en ambos lados, D-004).
- **Decisión:** Instrucción explícita del usuario: los arquetipos de construcción del prototipado (Descubridor y los que sigan, p. ej. Prototipador) viven **solo** en `template/.claude` (el entregable), **no** en la raíz `.claude/`. A diferencia de `sesion-starter`/`sesion-closer`/`register-harness` (que son herramientas que el propio proyecto Base Harness usa para construirse a sí mismo), estos arquetipos son **deliverable-only**: el proyecto harness no los necesita para su propia construcción, solo los proyectos que hereden el molde.
- **Alternativas consideradas:** Replicar también en la raíz `.claude/` por consistencia con el patrón de sincronización de D-004 (descartada: esos agentes no tienen ningún uso dentro de la construcción del harness mismo, solo agregaría mantenimiento sin beneficio).
- **Consecuencias:** La raíz `.claude/` queda limpia de arquetipos de prototipado. Al auditar/provisionar con `register-harness` para otras herramientas, la fuente de estos arquetipos específicos es `template/.claude`, no la raíz (matiz a tener en cuenta si `register-harness` se extiende para cubrir también estos arquetipos, ver T-023).

### D-023 — Observabilidad y evaluación de los agentes del Descubridor: diseño escrito, construcción diferida (E4)
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** Tras materializar el Descubridor como dos agentes (D-021), surgió la pregunta de cómo saber que `onboarding-interviewer` y `onboarding-writer` entregan su trabajo correctamente. `methodology.md` ya tiene el marco de dos ejes (§10 conformidad determinista *¿siguió el procedimiento?* vs §8 calidad con juez LLM *¿quedó bien?*) y el contrato de constructor (§5.1), pero ningún agente tenía su **perfil de conformidad** concreto escrito, y §9/E4 advierte que la maquinaria de observabilidad no se monta "de entrada". El usuario, ante la disyuntiva de alcance, eligió explícitamente **solo diseño, no construir**.
- **Decisión:** Escribir el diseño en tres sitios, **difiriendo la construcción** del motor de traza/checks y del arnés de juez hasta tener evidencia (E4/§9). **(1)** Perfil de conformidad de `onboarding-interviewer` (checks I1–I7: instanciación, append-only, persistencia inmediata, Single Writer, no-interpreta, reanudabilidad, cierre bien formado) + su política de evaluación de calidad: como su insumo es un diálogo en vivo sin fixture estático, el **juez LLM offline no aplica**; su calidad se mide por **cobertura** determinista del esqueleto `discovery_temp.md` (§1–§9 con ≥1 pregunta o hueco declarado) + **gate humano** autoritativo + retroalimentación al prompt (§8/§9). **(2)** Perfil de conformidad de `onboarding-writer` (checks W1–W6: lectura-antes-de-escritura, instanciación, estructura intacta, Single Write, completitud, Gatekeeper medible) + **oráculo de trazabilidad log→discovery** (T1–T4: actores, camino feliz, Gatekeeper y huecos declarados deben trazar al log — caza *invención*, habilitado por conservar el log, A-002) + candidatura a juez LLM offline diferida. **(3)** Esta decisión. Los perfiles se escriben en el prompt de cada agente (§10: "a cada agente se le añade su perfil de conformidad"); se ejecutan por inspección humana por ahora.
- **Alternativas consideradas:** (a) Construir todo para ambos agentes (dos capas completas + motor de traza agnóstico a 4 herramientas + fixtures + juez LLM) y luego probar — descartada: choca con E4/§9 (montar observabilidad sin evidencia de que hace falta), el motor de traza uniforme entre Claude Code/Codex/opencode/Gemini es un problema de infraestructura no resuelto (C-001), y se evaluaría en el vacío porque el consumidor del `discovery.md` (el Prototipador, T-022) aún no existe. (b) Spike solo del writer (perfil + oráculo de trazabilidad, corrida manual) — no elegido, pero queda como camino natural si más adelante se busca evidencia antes de construir el motor genérico. (c) No escribir nada y dejarlo implícito — descartada: sin perfiles escritos, la conformidad solo se detecta por inspección ad hoc.
- **Consecuencias:** Los dos agentes del Descubridor quedan con criterios explícitos de "entregó bien / mal" separando conformidad de calidad. El oráculo de trazabilidad da un argumento adicional para conservar `interview_document.md` (refuerza A-002). Queda **pendiente**, cuando haya evidencia (E4): el motor genérico de traza/conformidad, el dataset de fixtures con defectos sembrados y el juez LLM calibrado para el writer. El mismo patrón (perfil de conformidad por agente) deberá replicarse en el **Prototipador** (T-022) y demás arquetipos.

### D-024 — Conservar `interview_document.md` como traza junto a `discovery.md` (promoción de A-002)
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** `[[assumptions]] A-002` dejaba sin resolver si el log crudo de la entrevista (`interview_document.md`) debía conservarse tras la síntesis del writer o descartarse. `D-023` definió el oráculo de trazabilidad log→discovery del `onboarding-writer` (checks T1–T4: actores, camino feliz, Gatekeeper y huecos declarados deben trazar al log), que solo es posible si el log persiste después de generar `discovery.md`.
- **Decisión:** El usuario confirmó explícitamente CONSERVAR `interview_document.md` como traza junto a `discovery.md`; el log crudo **no** se descarta ni se limpia tras la síntesis. Motivo reforzado: conservar el log habilita el oráculo de trazabilidad de `D-023`, sin el cual no hay forma determinista de detectar invención en `discovery.md`.
- **Alternativas consideradas:** Descartar/archivar el log tras generar `discovery.md` (opción que barajaba `A-002` por ruido o privacidad de las respuestas) — descartada por el usuario: el valor de auditabilidad (oráculo de trazabilidad) pesa más que el ruido, y no se reportaron preocupaciones de privacidad en este proyecto.
- **Consecuencias:** `interview_document.md` y `discovery.md` conviven de forma permanente como par log-crudo/entregable-estructurado. El oráculo de trazabilidad de `D-023` queda habilitado sin ajustes adicionales. `A-002` queda promovida y cerrada (ver [[assumptions]]).

