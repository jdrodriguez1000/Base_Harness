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
| T-027 | Prueba end-to-end del flujo COMPLETO de prototipado (`client_brief` → reader → interviewer solo-huecos → writer → discovery.md → prototype-builder), usando el caso de reciclaje como fixture; engloba/encadena T-024 y T-026 sobre el mismo caso | en progreso (corrida 2 fracasada por reaparición de L-009; L-005/L-006/L-008 cerrados con evidencia) | alta |
| T-028 | Corregir `ingest-protocol` con los tres hallazgos de la ingesta: invariante anti-fabricación sobre el campo de salida (L-005), campo `Confirmado por el humano` que nace en `no` y solo se modifica en escritura separada (L-007), y estado `n/a` en la tabla de cobertura + su regla espejo en `interview-protocol` (L-008) | completada | alta |
| T-029 | Añadir a `ingest-protocol` una pasada final de consistencia **entre** áreas tras el bucle de extracción, con los cruces de alto riesgo nombrados (§6 vs §9, §5 vs §6, §7 vs §2), para capturar contradicciones transversales (L-006) | completada | alta |
| T-030 | Implementar el commit por etapa en los skills de etapa (`ingest`/`interview`/`discovery`/`prototype-protocol`) y un bootstrap de repo git al inicio del estadio, conforme a `principles.md:37` y `methodology.md:515` (L-009) | completada con reserva (el commit quedó condicionado al gate humano; reaparición de L-009 en la corrida 2 → reabierta parcialmente por T-042) | alta |
| T-031 | Auditoría sistemática de cobertura documentación↔ejecución: recorrer las conductas operativas impuestas por `methodology.md` y `principles.md` y verificar qué `SKILL.md` las implementan realmente (patrón repetido en L-004, L-008 y L-009) | completada | media |
| T-032 | Conservar el `client_brief.md` de reciclaje como fixture permanente versionado en `Base_Harness` (ubicación por decidir con el humano) | cancelada (decisión explícita del humano) | alta |
| T-033 | Definir el procedimiento de repetición de T-027: orden de ajustes, reset de `_prototype/`, `git init` del proyecto de prueba y criterios de aceptación por hallazgo | completada | alta |
| T-034 | G1 — Leer `git log` al iniciar sesión en `startup-protocol` (E1, E10) | completada | alta |
| T-035 | G5 — Aplicar la convención de commits `tipo(<alcance>): descripción` del Apéndice de `methodology.md` en `closing-protocol` Paso 6.3 | completada con reserva (convención aplicada; el criterio de L-007 que la corrida 2 destapó sigue incompleto, ver T-046) | alta |
| T-036 | G4 — Procedimiento del gate de madurez Prototipo→MVP (evidencia contra el Gatekeeper, feature freeze, registro de la decisión) | pendiente | media |
| T-037 | G6 — Implementar E12 (la sesión principal guarda su plan en memoria antes de crear subagentes) en `AGENTS.md` | pendiente | media |
| T-038 | G8 — Reanudación (E5) de `prototype-protocol`: hoy el bucle agéntico no deja checkpoint | pendiente | media |
| T-039 | G9 — Motor de traza + checker de conformidad determinista (E13/§10): los checks ya están escritos en los prompts pero nadie los ejecuta | pendiente | media |
| T-040 | G2 — Completar E10 en `startup-protocol` (verificar ambiente + prueba de sanidad) | pendiente | baja |
| T-041 | Alinear la semántica de `cubierta` para §7 entre `ingest-protocol` (métrica+umbral) y `discovery-protocol` (métrica+umbral+método) (L-011) | completada (alcance ampliado a `interview-protocol`, tercer skill afectado) | alta |
| T-042 | Desacoplar el commit de etapa del gate humano en `ingest-protocol` y `discovery-protocol`: el disparador es la salida de etapa, no la aprobación; si el artefacto está en borrador se confirma igual con `[sin confirmar]` en el mensaje (L-013). Reabre parcialmente T-030 | completada | alta |
| T-043 | Contrato de entrada entre etapas: cada skill verifica `Estado`/`Confirmado` del artefacto que consume y AVISA (no bloquea) si viene en borrador (L-014) | completada | alta |
| T-044 | `project.yaml` como insumo declarado desde el Paso 0 de los skills de etapa: metadatos de proyecto (fuente `project.yaml`) vs. contenido del cliente (fuente brief, `<no declarado>` si falta); todo valor lleva su procedencia (L-015) | completada | alta |
| T-045 | Checkpoints intra-etapa con commit (y push según decisión pendiente): commit eager en unidades naturales (bloque de preguntas, iteración del bucle), no por cada Q&A | completada (decisión de push resuelta: siempre locales, ver D-033) | alta |
| T-046 | Corregir el criterio de aceptación de L-007 en `T-027_procedimiento.md` para que "nunca se confirmó" cuente también como fallo (L-016) | completada | media |
| T-047 | Decidir si la precondición §2.5 de `T-027_procedimiento.md` (`git init` + commit inicial ANTES de invocar al primer agente) se mantiene o se retira: con ella, el bootstrap de `git-protocol.md` §2 nunca se ejercita durante la prueba | pendiente (decisión del humano, ver A-004) | media |

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

- [ ] T-047 — Decidir si la precondición §2.5 de `T-027_procedimiento.md` (`git init` + commit inicial ANTES de invocar al primer agente) se mantiene o se retira. Con ella, el bootstrap de `git-protocol.md` §2 —el mecanismo que existe justamente para que L-009 no se repita— **nunca se ejecuta** durante la prueba: la misma ceguera que la regla general de T-046 ("camino no ejercitado ≠ camino correcto"), aplicada al procedimiento mismo. Quitarla haría la corrida más fiel al caso real; mantenerla evita que un fallo de infraestructura tumbe la prueba. No decidido por el humano.
      Prioridad: media · Responsable: — · Ref: [[assumptions]] A-004, [[tasks]] T-027, [[lessons]] L-016
- [ ] T-036 — G4: procedimiento del gate de madurez Prototipo→MVP — evidencia contra el Gatekeeper (§7 del discovery), feature freeze, registro de la decisión de cruce. Hoy el gate se detecta conceptualmente (D-028, gate ④) pero ningún skill conduce el cruce: el estadio sabe empezar y no sabe terminar.
      Prioridad: media · Responsable: — · Ref: [[decisions]] D-028, [[tasks]] T-031
- [ ] T-037 — G6: implementar E12 (la sesión principal guarda su plan en memoria antes de crear subagentes) en `AGENTS.md`. Hoy E12 no está en `AGENTS.md` ni en ningún skill.
      Prioridad: media · Responsable: — · Ref: [[tasks]] T-031
- [ ] T-038 — G8: reanudación (E5) del `prototype-protocol` — hoy el bucle agéntico escribir→ejecutar→ajustar no deja checkpoint, a diferencia del `interview-protocol` (log append-only, D-021).
      Prioridad: media · Responsable: — · Ref: [[decisions]] D-021, D-026, [[tasks]] T-031
- [ ] T-039 — G9: motor de traza + checker de conformidad determinista (E13/§10). Gap mayor de la auditoría T-031: los checks de conformidad ya están escritos en los 4 prompts de agente (R1–R10/E1–E6, I1–I12, W1–W7/T1–T5, P1–P9) pero nadie los ejecuta todavía.
      Prioridad: media · Responsable: — · Ref: [[tasks]] T-031, [[decisions]] D-023, D-026
- [ ] T-040 — G2: completar E10 en `startup-protocol` (verificar ambiente + prueba de sanidad), hoy incompleto.
      Prioridad: baja · Responsable: — · Ref: [[tasks]] T-031
- [ ] T-041 — Alinear la semántica de `cubierta` para §7 entre `ingest-protocol` (métrica+umbral) y `discovery-protocol` (métrica+umbral+método), para que un área dada por cubierta por el reader no llegue corta al writer (L-011, misma clase que L-008). **Confirmada empíricamente en la corrida 2 de T-027**: §7 quedó `cubierta` sin método de medición (regresión frente a `parcial` en la corrida 1) — sube de prioridad.
      Prioridad: alta · Responsable: — · Ref: [[lessons]] L-011, L-008, [[tasks]] T-027
- [ ] T-023 — Re-sync a opencode/Gemini (vía `register-harness`) de los nuevos agentes/skills/plantillas del Descubridor Y del Prototipador: `onboarding-reader`, `onboarding-interviewer`, `onboarding-writer`, skills `ingest-protocol`/`interview-protocol`/`discovery-protocol`, plantillas `discovery_temp.md`/`interview_temp.md`/`document_extract_temp.md`/`client_brief_temp.md`, agente `prototype-builder`, skill `prototype-protocol`, más la detección de estadio de `startup-protocol` (Paso 4) y la sección "Arranque de proyecto" de `AGENTS.md`. **Ojo:** el inventario hardcodeado de `register-harness` hoy solo cubre los agentes de sesión (`sesion-starter`/`sesion-closer`) — hay que ampliarlo, no solo re-ejecutarlo (ver [[lessons]] L-003). **Deuda ampliada (2026-07-19):** T-042…T-046 tocaron además `git-protocol.md`, `methodology.md` (§0.2 y §5.1) y los cuatro `SKILL.md` de etapa — todo eso también debe re-sincronizarse.
      Prioridad: media · Responsable: — · Ref: [[progress]], [[decisions]] D-021, D-026, D-028, D-032, D-034, [[lessons]] L-003
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

- [~] T-027 — Prueba end-to-end del flujo COMPLETO de prototipado, con el caso de reciclaje como fixture: `client_brief` → `onboarding-reader` (`document_extract.md`) → `onboarding-interviewer` solo-huecos (`interview_document.md`) → `onboarding-writer` (`discovery.md`) → `prototype-builder` (`prototype/`), todo dentro de `_prototype/` (D-028). Engloba y encadena T-024 y T-026. Modalidad observador (D-029): la sesión del harness no ejecuta la prueba, actúa como validador.
      **Corrida 1** (`App_Reciclaje`) — Etapa 1 evaluada, 5 hallazgos: L-005 (nombre fabricado), L-006 (contradicción §5↔§8 no detectada), L-007 (confirmación prematura), L-008 (§3/§10 sin `n/a`), L-009 (sin commit, ni repo git).
      **Corrida 2** (`App_Reciclaje_2`, tras T-028/T-029/T-030/T-034/T-035) — **FRACASADA por reaparición de L-009**: el commit de etapa quedó condicionado al gate humano (T-030) y al saltarse el gate (D-029) el commit nunca se disparó; la ingesta se cerró y avanzó a la entrevista sin commit ni repo git. **L-005 CERRADO, L-006 CERRADO, L-008 CERRADO** (con evidencia). **L-007 pasa técnicamente pero por el motivo equivocado** (nunca se confirmó, en vez de confirmarse antes de tiempo — ver L-016/T-046). Hallazgos nuevos: §7 regresó a `cubierta` sin método (confirma L-011/T-041), `interview-protocol` consumió un extracto en borrador sin detectarlo (L-014), el interviewer atribuyó mal la procedencia del nombre "ReciclApp" (L-015). La corrida siguió por decisión del humano hasta entrevista en curso (6 preguntas respondidas).
      **T-042, T-043, T-044, T-041 y T-046 aplicadas y completadas** (ver `progress.md` 2026-07-19). **T-045 completada, decisión de push resuelta** (A-003 → D-033: checkpoints siempre locales, push solo al cierre). **Único bloqueante restante para la corrida 3:** sincronizar el proyecto de prueba desde `template/` (paso 11 de `T-027_procedimiento.md` §1). Cuestión abierta sin decidir: precondición `git init` previa al primer agente (ver T-047/A-004).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-026, D-027, D-028, D-029, D-033, D-034, [[lessons]] L-005…L-009, L-013…L-016, [[tasks]] T-042, T-043, T-044, T-045, T-046, T-047
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
- [x] T-031 — Auditoría sistemática de cobertura documentación↔ejecución: se recorrieron E1–E13/NC de `principles.md` y §4–§7/§10/Apéndice de `methodology.md` contra los 7 `SKILL.md` del molde (~10/20 conductas implementadas, ~5 parciales, ~5 ausentes). Divergencia concentrada en tres zonas: **git** (G1, G5, L-009), **fronteras de estadio** (G4, G7) y **sesión principal** (G6, G2, G9), más sueltos G3, G8, G10. De ahí nacen T-034…T-041.
      Prioridad: media · Responsable: — · Ref: [[progress]], [[tasks]] T-034, T-035, T-036, T-037, T-038, T-039, T-040, T-041, [[lessons]] L-004, L-008, L-009, L-010
- [x] T-028 — Corregidos los tres hallazgos de la ingesta en `ingest-protocol`: (a) regla anti-fabricación reescrita como invariante del **campo de salida** (todo valor trazable a una cita; si no, hueco `<no declarado>`), extendida a **todo** campo incluido Meta (L-005); (b) `Confirmado por el humano` nace en `no`/`borrador` en la plantilla y solo pasa a `sí`/`cerrado` en una escritura **posterior y separada** (L-007); (c) cuarto estado de cobertura `n/a` con guarda anti-atajo (§3 canónico, §10 condicional, el resto exige justificación; ante duda gana `ausente`) (L-008). Propagado a `document_extract_temp.md`, `interview-protocol`, `discovery-protocol`, `methodology.md` §5 y los prompts de `onboarding-reader`/`onboarding-interviewer`/`onboarding-writer` (checks R8–R10, E5–E6, I12, T6–T7).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[lessons]] L-005, L-007, L-008, [[tasks]] T-027
- [x] T-029 — Nuevo Paso 3 en `ingest-protocol`: pasada de consistencia **entre** áreas tras el bucle de extracción, con tabla de cruces de alto riesgo como piso (§6↔§9, §5↔§6, §7↔§2); las contradicciones se registran citando **ambos** extremos, sin resolverlas (las resuelve la entrevista, NC-1). Pasos renumerados (antiguo Paso 3 "confirmar" pasa a Paso 4). Captura la clase de defecto de L-006.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[lessons]] L-006, [[tasks]] T-027
- [x] T-033 — Procedimiento de repetición de T-027 escrito en `Base_Harness/T-027_procedimiento.md`: orden de ajustes (skills → re-sync T-023 → reset del fixture → re-ejecutar), preparación de la corrida (`_prototype/` limpio, `_context/client_brief.md` intacto, `git init`), **criterios de aceptación pasa/falla escritos ANTES de la corrida** por cada hallazgo (L-005…L-009 + G7) conforme a D-030, y criterios de la corrida completa. Incluye el caso borde de L-012 ("Recicladora Oriente Verde" es la empresa, no el proyecto) documentado como "aprobado con reparo".
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-030, [[lessons]] L-005, L-006, L-007, L-008, L-009, L-012, [[tasks]] T-027
- [x] T-030 — Commit por etapa implementado en los 4 skills del molde (`ingest-protocol` Paso 5, `interview-protocol` Paso 3, `discovery-protocol` Paso 3, `prototype-protocol` Paso 4), aplicando el protocolo único `template/_guideline/git-protocol.md` (D-032). **Con reserva:** el commit quedó condicionado a la confirmación/gate humano; en la corrida 2 de T-027 el humano saltó el gate y el commit nunca se disparó, reapareciendo L-009. Reabierta parcialmente por T-042 (desacoplar el disparador de la aprobación).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-031, D-032, [[lessons]] L-009, L-013, [[tasks]] T-034, T-035, T-042
- [x] T-034 — G1 completada: `startup-protocol` gana Paso 4 de lectura del repositorio (`git rev-parse`, `git log --oneline -10`, `git status --short`, rama), contrastado con `progress.md`; solo-lectura estricta; divergencia memoria↔repo se reporta, no se reconcilia (NC-6); pasos renumerados (estadio→Paso 5, síntesis→Paso 6); copias de raíz sincronizadas (G10).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-032, [[tasks]] T-030, T-035
- [x] T-035 — G5 completada: convención de commit `tipo(<alcance>): descripción` de `git-protocol.md` §4 aplicada en `closing-protocol` Paso 6.3, con criterio de elección de tipo y regla de omitir paréntesis en trabajo transversal. **Con reserva:** el criterio de aceptación de L-007 que la corrida 2 destapó incompleto (ciego a "nunca se confirmó") sigue sin corregir, ver T-046.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-031, D-032, [[lessons]] L-016, [[tasks]] T-030, T-034, T-046

- [x] T-042 — Desacoplado el commit de etapa del gate humano (cierra L-013). `git-protocol.md` §3: el disparador es la **salida de etapa**, no la aprobación; §4 gana el marcador de borrador `[sin confirmar]` (buscable con `git log --grep`), nunca presente en etapas sin gate. Aplicado en `ingest-protocol` y `discovery-protocol`; `prototype-protocol` ya tenía el patrón correcto, `interview-protocol` no tiene gate.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[lessons]] L-013, [[tasks]] T-030, T-027
- [x] T-043 — Contrato de entrada entre etapas (cierra L-014), integrado como **paso 0 de `methodology.md` §5.1** (D-034) en vez de un archivo `_guideline/` nuevo: cada skill lee `Estado`/`Confirmado por el humano` del insumo y AVISA (no bloquea, NC-6) si viene en borrador; insumo cuyo estado no se pueda leer = no confirmado. Aplicado en `interview-protocol`, `discovery-protocol` y `prototype-protocol`; `ingest-protocol` queda fuera (su insumo es el brief del cliente, sin campo de estado). Plantillas `interview_temp.md`/`discovery_temp.md` actualizadas.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-034, [[lessons]] L-014, [[tasks]] T-027
- [x] T-044 — `project.yaml` como insumo declarado (cierra L-015): `methodology.md` §0.2 fija "Dos clases de dato, dos fuentes" — metadatos de proyecto ← `project.yaml` (`<no declarado>` si falta) vs. contenido del cliente ← brief/entrevista (se pregunta si falta), sin cruzar fuentes. Los cuatro skills de etapa leen `project.yaml` en su Paso 0. Tres plantillas anotan la fuente en el campo `**Proyecto:**`. Asimetría deliberada documentada: ausente = `<no declarado>` en el extracto, pero se pregunta en la entrevista.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[lessons]] L-015, L-005, [[tasks]] T-028, T-027
- [x] T-041 — Alineada la semántica de `cubierta` para §7 (cierra L-011, ampliada): la desalineación era de **tres** skills, no de dos (`interview-protocol` también elicitaba solo dos componentes). Alineado hacia arriba (métrica + umbral + método de medición); `discovery-protocol` Paso 1.6 queda como definición canónica. `ingest-protocol` e `interview-protocol` alineados; criterio anotado en `document_extract_temp.md`.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[lessons]] L-011, L-008, [[tasks]] T-027
- [x] T-045 — Checkpoints intra-etapa con commit (A-003 resuelta → D-033: siempre locales, push solo al cierre). `git-protocol.md` gana §3.1: unidad = bloque natural (`interview` por bloque de preguntas o al interrumpirse; `prototype` por iteración ejecutable); nunca por Q&A suelto ni por edición de archivo; todo checkpoint lleva `[sin confirmar]`. `ingest`/`discovery` no llevan checkpoints (artefacto en una sola pasada). Aplicado en `interview-protocol` y `prototype-protocol`.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-033, [[assumptions]] A-003, [[tasks]] T-027
- [x] T-046 — Corregido el criterio de aceptación de L-007 en `T-027_procedimiento.md` (cierra L-016): añadido el tercer caso de fallo (la confirmación nunca ocurre) y regla general "camino no ejercitado ≠ camino correcto" (si no se ejercita, el hallazgo es NO EVALUADO, sigue abierto). Actualizado el criterio de L-009 (los commits `[sin confirmar]` de T-042 son correctos) y la tabla de orden de §1 (paso 11 = único bloqueante de la corrida 3).
      Prioridad: media · Responsable: — · Ref: [[progress]], [[lessons]] L-016, [[tasks]] T-027, T-035

## Cancelada

- [x] T-032 — Conservar el `client_brief.md` del caso de reciclaje como fixture permanente versionado en `Base_Harness`. **Cancelada por decisión explícita del humano.** Consecuencia registrada: la reproducibilidad de la prueba queda atada a que el brief de `Pruebas_Prototipado` sobreviva intacto fuera de este repo; si se pierde o edita, los criterios de `T-027_procedimiento.md` §3 dejan de ser verificables.
      Prioridad: — · Responsable: — · Ref: [[progress]], [[lessons]] L-005, L-006, L-009

## Bloqueadas
