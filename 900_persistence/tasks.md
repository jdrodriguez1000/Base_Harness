# Tasks

> Lista viva de tareas del proyecto. Fuente única de trabajo pendiente y en curso.
> Estados: `[ ]` pendiente · `[~]` en progreso · `[x]` completada · `[!]` bloqueada.

## Índice

> Mantener sincronizado: al crear/mover/cerrar una tarea, actualizar su fila aquí.
> Buscar por ID (`T-XXX`) para localizar la tarea sin leer todo el archivo.

| ID | Tarea | Estado | Prioridad |
|---|---|---|---|
| T-001 | Definir la estructura completa del harness base | completada | alta |
| T-002 | Mantener sincronizadas las dos copias de `.claude/` (raíz vs `template/.claude/`) | completada (absorbida por `register-harness`, ver D-004) | media |
| T-003 | Rellenar `905_context/business.md` con los datos reales de la empresa | pendiente | alta |
| T-004 | Evaluar hooks SessionStart/Stop para forzar técnicamente los protocolos de inicio/cierre | pendiente | media |
| T-005 | Decidir si `business.md` se versiona (posible información sensible) o va a `.gitignore` | pendiente | media |
| T-006 | Añadir IDs `P-XXX` a `progress.md` para uniformar la búsqueda por ID | pendiente | baja |
| T-007 | Crear `.gitignore` agnóstico y hacer el primer `git push` a GitHub | completada | alta |
| T-008 | Fase de PROVISIÓN de `register-harness` para opencode (crear `.opencode/skills` copiando `SKILL.md`, traducir agentes a formato opencode, asegurar `AGENTS.md` en raíz) | completada | alta |
| T-009 | Espejar el procedimiento de `register-harness` dentro de `AGENTS.md` + autoprovisión (resolver la bootstrap-paradoja para poder ejecutarlo desde dentro de opencode) | completada | media |
| T-010 | Extender `register-harness` a Codex y Gemini | en progreso (Gemini hecho, falta Codex) | media |
| T-011 | Verificar mecanismos de Gemini (`GEMINI.md`, comandos) con documentación oficial | completada | media |
| T-012 | Re-provisionar (`re-sync`) `proyecto_prueba` para recoger los cambios de T-008/T-009 (modelos, descripciones de agentes, autosuficiencia, README) | pendiente | alta |
| T-013 | Provisionar un `.gemini/` real en un proyecto destino para validar de punta a punta la fase de provisión de Gemini | pendiente | media |
| T-014 | Cablear `template/_guideline/principles.md` como comportamiento vinculante en `AGENTS.md`, `CLAUDE.md`, agentes de sesión y `register-harness` | completada | alta |
| T-015 | Crear `template/_guideline/methodology.md` agnóstico (dos ejes, arquetipos, ciclo de vida) + diferenciación Prototipo (deseabilidad/factibilidad) vs MVP | completada | alta |
| T-016 | Segunda ronda de `methodology.md`: elimina prototipado por-incremento, añade contratos/flujos de observabilidad-evaluación (entregables y código), Revisor de código, especialización de flota; simplifica `AGENTS.md` | completada | alta |
| T-017 | Tercera ronda de `methodology.md`: §7.1 estado por incremento (`state.yaml`) — espina única, capas etiquetadas, Single Writer, hermano de seguridad (§5.2) | completada (modelo base; gates/TDD continúan en T-018) | alta |
| T-018 | Modelar en `state.yaml` los gates con sus resoluciones y los casos TDD dentro de Construir; plantilla física `template/_templates/state_temp.yaml` | completada | alta |
| T-019 | Cablear `methodology.md` en `template/AGENTS.md` (sección "Metodología de construcción", hermana de la de `principles.md`) | completada | alta |
| T-020 | Prototipado Parte 1 (método): taxonomía de actores por defecto (§4.3) y arquetipo Descubridor (§5) conectado con el Prototipador | completada | alta |
| T-021 | Prototipado Parte 2 (Descubridor): plantilla `_templates/discovery_temp.md` + arquetipo Descubridor materializado como dos agentes (`onboarding-interviewer` + `onboarding-writer`), `_templates/interview_temp.md` | completada | alta |
| T-022 | Prototipado Parte 2 (Prototipador): construir el agente+skill `prototype-builder`/`prototype-protocol` (patrón wrapper+skill), reubicación de la frontera §4.2 (D-025) y observabilidad §10 (D-026) | completada | alta |
| T-023 | Re-sync a opencode/Gemini de los nuevos agentes/skills/plantillas del Descubridor y del Prototipador (`onboarding-reader`, `onboarding-interviewer`, `onboarding-writer`, `ingest-protocol`, `interview-protocol`, `discovery-protocol`, `prototype-builder`, `prototype-protocol`) vía `register-harness`, incluyendo ahora la detección de estadio de `startup-protocol` y la sección "Arranque de proyecto" de `AGENTS.md` | pendiente | media |
| T-024 | Probar `prototype-builder` end-to-end con un `discovery.md` real (usar el caso de reciclaje como fixture) | pendiente (ver T-027) | alta |
| T-025 | Ruta documental del Descubridor: agente `onboarding-reader` + skill `ingest-protocol` + plantilla `document_extract_temp.md`; interviewer entrevista solo los huecos; writer con dos insumos (D-027) | completada | alta |
| T-026 | Probar la ruta documental end-to-end con un `client_brief` real: verificar que el interviewer no repregunta lo cubierto y que el `discovery.md` no pierde material del documento | pendiente (ver T-027) | alta |
| T-027 | Prueba end-to-end del flujo COMPLETO de prototipado (`client_brief` → reader → interviewer solo-huecos → writer → discovery.md → prototype-builder), usando el caso de reciclaje como fixture; engloba/encadena T-024 y T-026 sobre el mismo caso | en progreso (ingesta evaluada: L-005…L-009) | alta |
| T-028 | Corregir `ingest-protocol` con los tres hallazgos de la ingesta: invariante anti-fabricación sobre el campo de salida (L-005), campo `Confirmado por el humano` que nace en `no` y solo se modifica en escritura separada (L-007), y estado `n/a` en la tabla de cobertura + su regla espejo en `interview-protocol` (L-008) | pendiente | alta |
| T-029 | Añadir a `ingest-protocol` una pasada final de consistencia **entre** áreas tras el bucle de extracción, con los cruces de alto riesgo nombrados (§6 vs §9, §5 vs §6, §7 vs §2), para capturar contradicciones transversales (L-006) | pendiente | alta |
| T-030 | Implementar el commit por etapa en los skills de etapa (`ingest`/`interview`/`discovery`/`prototype-protocol`) y un bootstrap de repo git al inicio del estadio, conforme a `principles.md:37` y `methodology.md:515` (L-009) | pendiente | alta |
| T-031 | Auditoría sistemática de cobertura documentación↔ejecución: recorrer las conductas operativas impuestas por `methodology.md` y `principles.md` y verificar qué `SKILL.md` las implementan realmente (patrón repetido en L-004, L-008 y L-009) | pendiente | media |
| T-032 | Conservar el `client_brief.md` de reciclaje como fixture permanente versionado en `Base_Harness` (ubicación por decidir con el humano) | pendiente | alta |
| T-033 | Definir el procedimiento de repetición de T-027: orden de ajustes, reset de `_prototype/`, `git init` del proyecto de prueba y criterios de aceptación por hallazgo | pendiente | alta |

## Convención de ID

- Cada tarea tiene un ID estable: `T-001`, `T-002`, ...
- No reutilizar IDs de tareas eliminadas.
- Las subtareas se anidan bajo su tarea padre.

## Formato

```
- [ ] T-001 — <descripción de la tarea>
      Prioridad: alta | media | baja · Responsable: <agente/persona> · Ref: [[progress]]
```

---

## Backlog

- [ ] T-028 — Corregir `ingest-protocol` con los tres hallazgos de la ingesta de T-027: (a) sustituir la prohibición de *citar* marcadores por una **invariante sobre el campo de salida** — todo valor debe ser trazable a una cita; si no lo es, va como hueco (`<sin dato en el brief>`), nunca como invención plausible ([[lessons]] L-005); (b) el campo `Confirmado por el humano` nace en `no` al crear el artefacto y solo se modifica en una **escritura posterior separada**, disparada por la respuesta del humano (L-007); (c) añadir el estado **`n/a`** a la tabla de cobertura para §3/§10 y su **regla espejo** en `interview-protocol` (*n/a → no preguntar*) (L-008).
      Prioridad: alta · Responsable: — · Ref: [[lessons]] L-005, L-007, L-008
- [ ] T-029 — Añadir a `ingest-protocol` una **pasada final de consistencia entre áreas**, posterior al bucle de extracción del Paso 2, con los cruces de alto riesgo nombrados explícitamente: camino feliz §6 vs. exclusiones §9, actores §5 vs. §6, Gatekeeper §7 vs. hipótesis §2. El bucle por casilleros es estructuralmente ciego a las contradicciones transversales ([[lessons]] L-006).
      Prioridad: alta · Responsable: — · Ref: [[lessons]] L-006
- [ ] T-030 — Implementar el **commit por etapa** en los skills de etapa (`ingest-protocol`, `interview-protocol`, `discovery-protocol`, `prototype-protocol`) y un **bootstrap de repo git** al inicio del estadio de Prototipo, conforme a `principles.md:37` y `methodology.md:515` §7. Hoy solo `closing-protocol` toca git, y un proyecto puede recorrer el descubrimiento completo sin control de versiones sin que nadie lo detecte ([[lessons]] L-009).
      Prioridad: alta · Responsable: — · Ref: [[lessons]] L-009
- [ ] T-031 — Auditoría sistemática de cobertura **documentación↔ejecución**: recorrer las conductas operativas impuestas por `methodology.md` y `principles.md` y verificar qué `SKILL.md` las implementan realmente. El patrón ya apareció tres veces (L-004 gates humanos, L-008 estado `n/a` entre skills, L-009 commit por etapa): la divergencia es sistemática, no incidental, y merece una verificación de cobertura en vez de parches caso a caso.
      Prioridad: media · Responsable: — · Ref: [[lessons]] L-004, L-008, L-009
- [ ] T-032 — Conservar el `client_brief.md` del caso de reciclaje como **fixture permanente** del harness, versionado en `Base_Harness`. Hoy vive solo en el proyecto de prueba (`Pruebas_Prototipado/App_Reciclaje/_context/`), fuera de control de versiones (L-009): si ese directorio se pierde o se edita, la prueba deja de ser reproducible y los hallazgos L-005…L-008 dejan de ser verificables. **Decisión abierta (para el humano):** dónde ubicarlo — no crear estructura nueva en el repo sin acordarlo (NC-6). Candidatos: `910_fixtures/`, o `template/_templates/ejemplos/` si se quiere que viaje con el molde como ejemplo. **Ojo:** si viaja dentro de `template/`, deja de ser un fixture de este proyecto y pasa a ser contenido del entregable — evaluar antes.
      **Por qué este brief:** resultó un fixture hostil de calidad, en parte por accidente — marcador de plantilla sin rellenar (dispara L-005), contradicción interna real §5↔§8 (L-006), duda declarada por el cliente en §10 (que el reader capturó bien como A4) y métricas sin método de medición (§7 parcial). Un brief sintético limpio no habría destapado ninguno de los cinco hallazgos.
      Prioridad: alta · Responsable: — · Ref: [[lessons]] L-005, L-006, L-009
- [ ] T-033 — Definir el **procedimiento de repetición** de la prueba T-027, para poder re-correrla tras aplicar T-028/T-029/T-030 y comprobar que los hallazgos quedaron cerrados. Debe cubrir: (a) **orden obligatorio** — corregir los skills en `template/.claude/` → re-sync (T-023) → resetear el proyecto de prueba → re-ejecutar; (b) **reset del fixture** — borrar `_prototype/` completo (los artefactos actuales están contaminados: nombre fabricado, confirmación falsa, cobertura sin `n/a`) dejando `_context/client_brief.md` intacto; (c) `git init` del proyecto de prueba, para que esta vez el commit por etapa de T-030 tenga dónde escribir; (d) **criterios de aceptación por hallazgo** — qué debe verse para dar cada lección por cerrada (p. ej. L-006: el extracto registra una ambigüedad sobre validación de correo y baja §6/§9 a `parcial`).
      **Nota de conducción:** en la corrida actual §3/§10 se dejaron correr sin corregir a propósito, para producir evidencia observable del gap de L-008. Al repetir, ese comportamiento ya no debe aparecer.
      Prioridad: alta · Responsable: — · Ref: [[lessons]] L-005…L-009
- [ ] T-023 — Re-sync a opencode/Gemini (vía `register-harness`) de los nuevos agentes/skills/plantillas del Descubridor Y del Prototipador: `onboarding-reader`, `onboarding-interviewer`, `onboarding-writer`, skills `ingest-protocol`/`interview-protocol`/`discovery-protocol`, plantillas `discovery_temp.md`/`interview_temp.md`/`document_extract_temp.md`/`client_brief_temp.md`, agente `prototype-builder`, skill `prototype-protocol`, más la detección de estadio de `startup-protocol` (Paso 4) y la sección "Arranque de proyecto" de `AGENTS.md`. **Ojo:** el inventario hardcodeado de `register-harness` hoy solo cubre los agentes de sesión (`sesion-starter`/`sesion-closer`) — hay que ampliarlo, no solo re-ejecutarlo (ver [[lessons]] L-003).
      Prioridad: media · Responsable: — · Ref: [[progress]], [[decisions]] D-021, D-026, D-028, [[lessons]] L-003
- [ ] T-024 — Probar `prototype-builder` end-to-end con un `discovery.md` real (usar el caso de reciclaje como fixture); sin esta evidencia el motor genérico de traza/conformidad y el juez LLM calibrado siguen diferidos por E4. **Encadenada dentro de T-027.**
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-026
- [ ] T-026 — Probar la **ruta documental** (D-027) end-to-end con un `client_brief` real: que el `onboarding-reader` marque bien la cobertura, que el `onboarding-interviewer` **no repregunte** lo cubierto, y —el fallo más caro— que el `discovery.md` **no pierda** el material que venía solo del documento (checks W0/T5). **Encadenada dentro de T-027.**
      Prioridad: alta · Responsable: — · Ref: [[decisions]] D-027
- [ ] T-012 — Re-provisionar (`re-sync`) `proyecto_prueba` para recoger los cambios de T-008/T-009: modelos destino (`openai/gpt-5.6-luna` / `-terra`), nuevas `description` de agentes, autosuficiencia (`register-harness` nativo en `.opencode/`), sección de portabilidad en `AGENTS.md` y `README.md`.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-005
- [ ] T-003 — Rellenar `905_context/business.md` con los datos reales de la empresa.
      Prioridad: alta · Responsable: — · Ref: [[progress]]
- [ ] T-004 — Evaluar hooks SessionStart/Stop para forzar técnicamente los protocolos de inicio/cierre.
      Prioridad: media · Responsable: — · Ref: [[progress]]
- [ ] T-005 — Decidir si `business.md` se versiona (posible información sensible) → `.gitignore`.
      Prioridad: media · Responsable: — · Ref: [[progress]]
- [ ] T-006 — Considerar añadir IDs `P-XXX` a `progress.md` para uniformar la búsqueda por ID.
      Prioridad: baja · Responsable: — · Ref: [[progress]]
- [ ] T-013 — Provisionar un `.gemini/` real en un proyecto destino para validar de punta a punta la fase de provisión de Gemini (análoga a la validación ya hecha con opencode).
      Prioridad: media · Responsable: — · Ref: [[progress]]

## En progreso

- [~] T-027 — Prueba end-to-end del flujo COMPLETO de prototipado, con el caso de reciclaje como fixture: `client_brief` → `onboarding-reader` (`document_extract.md`) → `onboarding-interviewer` solo-huecos (`interview_document.md`) → `onboarding-writer` (`discovery.md`) → `prototype-builder` (`prototype/`), todo dentro de `_prototype/` (D-028). Engloba y encadena T-024 y T-026. Se ejecuta en `C:\Users\USUARIO\Documents\Company_TripleS\Pruebas_Prototipado\App_Reciclaje` (terminal aparte); la sesión del harness actúa como **observador/validador**, no ejecuta la prueba.
      **Etapa 1 — ingesta: evaluada.** Correcto: citas fieles con elisiones marcadas, 5 ambigüedades registradas sin resolver (A4 cruza bien la §10 del brief con el flujo), fuera-de-alcance declarado, §7 en `parcial` pese a tener métrica+umbral (sesgo hacia el hueco funcionando), §5 bien marcada `cubierta` (el brief sí identifica al generador). Hallazgos: L-005 (nombre "ReciclApp" fabricado), L-006 (contradicción §5↔§8 del brief no detectada — la más cara), L-007 (confirmación prematura), L-008 (§3/§10 en `ausente` → entrarán a la entrevista), L-009 (sin commit; el proyecto ni siquiera es repo git).
      **Decisión de conducción:** §3/§10 se dejan correr sin corregir, para que la prueba produzca evidencia de que el gap de L-008 es real y observable en la entrevista.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-026, D-027, D-028, [[lessons]] L-005…L-009
- [~] T-010 — Extender `register-harness` a Codex y Gemini. Gemini completado (Paso 4 del skill, verificado con doc oficial vía ctx7); falta Codex.
      Prioridad: media · Responsable: — · Ref: [[progress]], [[decisions]] D-004

## Completadas

- [x] T-001 — Definir la estructura completa del harness base.
      Prioridad: alta · Responsable: — · Ref: [[progress]]
- [x] T-002 — Mantener sincronizadas las dos copias de `.claude/` (raíz vs `template/.claude/`). Absorbida/reemplazada por el skill `register-harness`, que la convierte en un procedimiento auditable y (a futuro) automatizable en vez de sincronización manual.
      Prioridad: media · Responsable: — · Ref: [[progress]], [[decisions]] D-004
- [x] T-007 — Crear `.gitignore` agnóstico (SO, editores, secretos, logs, deps) y hacer el primer `git push` a `https://github.com/jdrodriguez1000/Base_Harness.git` (rama `main`).
      Prioridad: alta · Responsable: — · Ref: [[progress]]
- [x] T-008 — Fase de PROVISIÓN de `register-harness` para opencode: skills por copia directa, agentes por traducción de frontmatter (tablas de campos/tools/modelos), con puerta de confirmación. Incluye los dos ajustes posteriores: `description` de agentes con frases naturales (activación) y modelos destino `openai/gpt-5.6-luna` / `-terra` (suscripción, no API Anthropic).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-004, [[lessons]] L-002
- [x] T-009 — Resolver la bootstrap-paradoja para opencode: sección *Portabilidad del harness* en `AGENTS.md` (espejo del procedimiento) + autoprovisión de `register-harness` en `.opencode/skills/` (autosuficiencia). Documentada la regla de oro y el modo re-sync.
      Prioridad: media · Responsable: — · Ref: [[progress]], [[decisions]] D-005
- [x] T-011 — Verificar mecanismos de Gemini (skills nativos en `.gemini/skills/<n>/SKILL.md`, agentes en `.gemini/agents/<n>.md`) con documentación oficial (ctx7 + web) antes de extender `register-harness`.
      Prioridad: media · Responsable: — · Ref: [[progress]], [[tasks]] T-010
- [x] T-014 — Cablear `template/_guideline/principles.md` (confirmado agnóstico, P1–P8/E1–E13/NC-1…NC-6) como comportamiento vinculante en `template/AGENTS.md`, `CLAUDE.md`, agentes de sesión (`sesion-starter`/`sesion-closer`, ambas copias) y `register-harness` (fuente única de verdad/baseline).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-007
- [x] T-015 — Crear `template/_guideline/methodology.md` agnóstico (dos tipos de proyecto, dos ejes madurez/incremento, ciclo de vida de 13 pasos, arquetipos de agente) y reescribir §4 (Estadios de madurez) con la distinción Prototipo deseabilidad/factibilidad y la frontera dura Prototipo→MVP.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-008, D-009
- [x] T-016 — Segunda ronda de `methodology.md`: elimina "Prototipar" como fase por-incremento (ciclo 13→11 pasos + spikes de excepción), añade §5.1 (contrato constructor de entregables), §10.1 (flujo observabilidad), §8.1 (flujo evaluación), §3.1 (observabilidad/evaluación TDD), §5.2 (Revisor de código), §5.3 (especialización de flota) y tabla de contenidos; simplifica `template/AGENTS.md` de 273 a 101 líneas (regla de diseño: marco mínimo + punteros, sin duplicar procedimientos).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-010, D-011, D-012, D-013, [[assumptions]] A-001
- [x] T-017 — Tercera ronda de `methodology.md`: §7.1 estado por incremento (`state.yaml`) — espina única de 11 pasos, capas técnicas como tareas etiquetadas (`component`/`owner`), revisiones transversales como entradas de evaluación en Verificar, Single Writer (orquestador), reanudación vía rama de la slice; §5.2 nota "hermano de seguridad" (`security-reviewer`).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-014, D-015, D-016, D-017
- [x] T-018 — Modelar en `state.yaml` los gates con sus resoluciones (modelo reutilizable aplicable a pasos 5/7/11) y los casos TDD dentro de Construir (`stage`, `caracterizacion`); plantilla física creada en `template/_templates/state_temp.yaml`; §7.1 de `methodology.md` enriquecida con el árbol de `_increments/<id>/`.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-018
- [x] T-019 — Cablear `methodology.md` en `template/AGENTS.md` (sección "Metodología de construcción", hermana de la de `principles.md`); referencia va en `AGENTS.md` (SSOT), no en `CLAUDE.md`.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-019
- [x] T-020 — Prototipado Parte 1 (método): §4.3 taxonomía de actores por defecto (GENERADOR→OPERADOR→ADMINISTRADOR, piso no techo, prioridad no lineal), §5 nuevo arquetipo Descubridor (conecta con el Prototipador, orden Descubridor→Prototipador), ajuste de §4.2 (frontera humano↔agente).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-020
- [x] T-021 — Prototipado Parte 2 (Descubridor): plantilla `template/_templates/discovery_temp.md` (10 secciones del entregable de descubrimiento); arquetipo Descubridor materializado como dos agentes — `onboarding-interviewer` (+ skill `interview-protocol`, conduce la entrevista, log append-only reanudable `interview_document.md`) y `onboarding-writer` (+ skill `discovery-protocol`, subagente autónomo que sintetiza el log en `discovery.md`); plantilla `template/_templates/interview_temp.md`; nota en `methodology.md` §5. Todo solo en `template/.claude` (deliverable-only). Continuación: perfiles de conformidad §10 escritos en ambos agentes (checks I1–I7 / W1–W6), oráculo de trazabilidad log→discovery (T1–T4), y confirmación de conservar `interview_document.md` como traza.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-021, D-022, D-023, D-024, [[assumptions]] A-002
- [x] T-022 — Prototipado Parte 2 (Prototipador): reubicación de la frontera humano↔agente de *deseabilidad/factibilidad* a *juicio vs. materialización* (§4.2, D-025), con la "regla de medio" y el campo medio/canal por actor (§6 de `discovery_temp.md`, elicitado en `interview-protocol`/`discovery-protocol`); arquetipo Prototipador materializado como un solo agente `prototype-builder` + skill `prototype-protocol` (deliverable-only, autónomo pero agéntico, ramifica por §3 discovery, construye solo el camino feliz del generador, artefacto en `<estadio-prototipo>/prototype/`), con perfil de conformidad §10 (checks P1–P8), oráculo de trazabilidad discovery→prototype (T1–T2) y evaluación anclada al Gatekeeper humano (D-026).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-025, D-026
- [x] T-025 — Ruta documental del Descubridor (D-027): el arquetipo pasa de dos a **tres agentes**. Nuevo `onboarding-reader` + skill `ingest-protocol` + plantilla `_templates/document_extract_temp.md`: busca `_context/client_brief.*` (nombre fijo, extensión libre); si no existe no escribe nada y el flujo cae a la entrevista completa; si existe confirma el archivo, extrae **citas textuales localizadas** por área §1–§10 en `document_extract.md` con **tabla de cobertura** (cubierta/parcial/ausente), **ambigüedades sin resolver** y material fuera de alcance, y cierra con **confirmación por bloque**. El `onboarding-interviewer` entrevista **solo los huecos** (checks nuevos I8–I11) y no duplica el extracto en su log; el `onboarding-writer` pasa a **dos insumos** (check W0, universo de traza log ∪ extracto, nuevo T5) con regla de precedencia *la entrevista manda, la discrepancia se declara*. Observabilidad del reader: R1–R7 + oráculo brief→extract E1–E4. Actualizados también `methodology.md` §5 (tres agentes + flujo del estadio), `interview_temp.md` y `prototype-builder` (P7).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-027

## Bloqueadas
