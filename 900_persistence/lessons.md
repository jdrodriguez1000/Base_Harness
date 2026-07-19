# Lessons Learned

> Conocimiento acumulado: errores cometidos, cómo se resolvieron y qué hacer distinto.
> Objetivo: que ningún agente repita un error ya resuelto en una sesión anterior.

## Índice

> Mantener sincronizado: al registrar una lección, añadir su fila aquí.
> Buscar por ID (`L-XXX`) para localizar la lección sin leer todo el archivo.

| ID | Lección | Fecha |
|---|---|---|
| L-001 | Duplicar `.claude/` (raíz vs `template/.claude/`) autocontiene el entregable pero crea riesgo de desincronización | 2026-07-17 |
| L-002 | En opencode, skills y subagentes compiten por su `description`; el subagente no se activa si le faltan las frases naturales del usuario | 2026-07-17 |
| L-003 | El inventario de agentes/skills de `register-harness` está hardcodeado y no crece solo cuando se añaden arquetipos nuevos al molde | 2026-07-19 |
| L-004 | Documentar un gate humano en `AGENTS.md` no lo implementa: hay que verificar el `SKILL.md` que lo ejecuta | 2026-07-19 |
| L-005 | Prohibir *citar* un marcador de plantilla no impide *rellenarlo*: el reader inventó el nombre del proyecto | 2026-07-19 |
| L-006 | La extracción área por área no detecta contradicciones **entre** áreas: falta un paso de cruce | 2026-07-19 |
| L-007 | Escribir el campo `Confirmado por el humano: sí` antes de pedir la confirmación falsea la traza | 2026-07-19 |
| L-008 | La tabla de cobertura no tiene estado `n/a`: §3 y §10 se marcan `ausente` y el interviewer las pregunta | 2026-07-19 |
| L-009 | "Commit por etapa" está en `methodology.md` pero ningún skill de etapa lo implementa (solo `closing-protocol` toca git) | 2026-07-19 |
| L-010 | Editar una capa (mover un campo) sin recorrer las demás rompe silenciosamente al consumidor — mismo patrón que audita T-031, autogenerado en la misma sesión | 2026-07-19 |
| L-011 | "Cubierta" significa cosas distintas en `ingest-protocol` y `discovery-protocol` para §7 (métrica+umbral vs. métrica+umbral+método): el mismo estado enumerado, dos contratos distintos | 2026-07-19 |
| L-012 | Una regla anti-fabricación correcta al pie de la letra puede fallar su intención: el nombre de la empresa aparece literal en el brief pero no es el nombre del proyecto | 2026-07-19 |
| L-013 | Condicionar el commit de etapa al gate humano deja sin commit si el humano salta el gate — reaparición de L-009 | 2026-07-19 |
| L-014 | `interview-protocol` consume un extracto en `borrador` sin detectarlo: no hay contrato de entrada entre etapas | 2026-07-19 |
| L-015 | El interviewer atribuyó mal la procedencia de un dato: inventó la fuente ("venía del brief"), no el valor | 2026-07-19 |
| L-016 | El criterio de aceptación de L-007 es ciego a "nunca se confirmó", solo contempla "se confirmó antes de tiempo" | 2026-07-19 |

## Formato

```
### L-001 — <título de la lección>
- **Contexto:** qué se estaba haciendo.
- **Problema:** qué salió mal o qué no era obvio.
- **Solución / aprendizaje:** qué funcionó y por qué.
- **Cómo aplicarlo:** regla accionable para el futuro.
- **Fecha:** YYYY-MM-DD
```

---

## Lecciones

### L-001 — Duplicar `.claude/` (raíz vs `template/.claude/`) autocontiene el entregable pero crea riesgo de desincronización
- **Contexto:** Se copiaron (no movieron) `.claude/agents` y `.claude/skills` de la raíz a `template/.claude/` para que el entregable `template/` fuera autocontenido y usable de forma independiente.
- **Problema:** Al haber dos copias físicas de los mismos skills/agentes, cualquier cambio futuro en la raíz (correcciones, nuevas versiones) no se propaga automáticamente a `template/.claude/`, y viceversa. Sin disciplina o automatización, ambas copias pueden divergir silenciosamente.
- **Solución / aprendizaje:** Se documentó explícitamente que la raíz es la fuente de verdad y `template/.claude/` es un reflejo; se registró como tarea pendiente (T-002) evaluar un script de re-copia.
- **Cómo aplicarlo:** Antes de dar por cerrada una sesión que tocó skills/agentes, verificar si `template/.claude/` necesita re-sincronizarse; no asumir que un cambio en la raíz ya se refleja en el entregable.
- **Fecha:** 2026-07-17

### L-002 — En opencode los skills y subagentes compiten por su `description`
- **Contexto:** Tras provisionar el harness en opencode, el usuario dio la instrucción "iniciemos la sesión" esperando que se activara el subagente `sesion-starter`, pero se ejecutó directamente el skill `startup-protocol`.
- **Problema:** En opencode, un subagente se invoca automáticamente **según su `description`** (o manualmente con `@nombre`), igual que un skill. Ambos compiten por la misma intención del usuario. La `description` de `sesion-starter` no contenía la frase natural "iniciemos la sesión" (solo "protocolo de inicio", "ponte al día", etc.), así que el agente principal eligió el skill, que sí matcheaba mejor.
- **Solución / aprendizaje:** Enriquecer la `description` de los agentes con las **frases naturales** que el usuario realmente dice ("iniciemos/cierra la sesión", etc.) y marcarlos como punto de entrada preferido. Alternativa siempre disponible en opencode: forzar el subagente con `@sesion-starter` / `@sesion-closer`.
- **Cómo aplicarlo:** Al crear o traducir un agente cuya activación deba ganarle a un skill homónimo, front-loadear en su `description` los disparadores literales del usuario. La `description` no es decorativa: es el criterio de enrutamiento.
- **Fecha:** 2026-07-17

### L-003 — El inventario de `register-harness` está hardcodeado y no crece solo con nuevos arquetipos
- **Contexto:** Durante T-025 (ruta documental del Descubridor, D-027) se añadió un tercer agente (`onboarding-reader`) y un tercer skill (`ingest-protocol`) al molde. Al revisar `register-harness` para planificar T-023 (re-sync a opencode/Gemini) se detectó que su lista de "qué auditar/provisionar" está **hardcodeada** en el propio `SKILL.md` y hoy solo enumera los agentes de sesión (`sesion-starter`/`sesion-closer`); nunca incluyó a `onboarding-interviewer`/`onboarding-writer`/`prototype-builder`, ni ahora a `onboarding-reader`.
- **Problema:** Cada vez que se añade un arquetipo nuevo al molde (`template/.claude/agents` + `.../skills`), `register-harness` no lo detecta automáticamente: hay que acordarse de ampliar su inventario a mano. Si no se hace, el skill audita/provisiona de forma incompleta sin avisar que algo falta en su propia lista.
- **Solución / aprendizaje:** Antes de re-ejecutar `register-harness` para sincronizar una herramienta destino, verificar que su inventario interno cubre **todos** los agentes/skills existentes en `template/.claude/`, no solo los de sesión. T-023 ya quedó ampliada para exigir esta revisión explícitamente.
- **Cómo aplicarlo:** Al crear un agente/skill nuevo deliverable-only en `template/.claude/` (D-022), añadirlo también al inventario de `register-harness` en la misma sesión (o dejarlo anotado como deuda explícita en `tasks.md`), en vez de asumir que el skill los descubre solo.
- **Fecha:** 2026-07-19

### L-004 — Documentar un gate humano en `AGENTS.md` no lo implementa
- **Contexto:** Al escribir la nueva sección "Arranque de proyecto" en `AGENTS.md` (D-028) se documentó que "entre el paso 3 y el 4 hay un gate humano" (cierre del discovery antes de pasar al Prototipador). Al verificar el `SKILL.md` que realmente ejecuta ese paso (`discovery-protocol`), resultó **falso**: el procedimiento decía "marcar el entregable como cerrado" sin pedir aprobación explícita al humano. Se encontró el mismo defecto en `interview-protocol`: cerraba la entrevista por su cuenta, sin esperar el OK del humano.
- **Problema:** Un gate humano descrito en la documentación de alto nivel (`AGENTS.md`) puede no existir en la práctica si el procedimiento operativo (`SKILL.md`) que lo ejecuta no lo implementa. La documentación y la ejecución pueden divergir silenciosamente incluso dentro de la misma sesión en que se escribió la documentación.
- **Solución / aprendizaje:** Se corrigió `discovery-protocol` (su Paso 2.3 ahora pide aprobación explícita del humano y el entregable queda en borrador hasta obtenerla, + regla invariante nueva) y `interview-protocol` (propone el cierre y espera el OK del humano en vez de cerrar por su cuenta).
- **Cómo aplicarlo:** Cada vez que se documente un "gate humano" (o cualquier paso de aprobación) en un archivo de alto nivel (`AGENTS.md`, `methodology.md`), verificar el `SKILL.md` operativo correspondiente para confirmar que efectivamente pide y espera esa aprobación, en vez de asumir que la mención documental basta.
- **Fecha:** 2026-07-19

### L-005 — Prohibir *citar* un marcador de plantilla no impide *rellenarlo*
- **Contexto:** Prueba T-027, paso de ingesta. El `client_brief.md` del caso de reciclaje conservaba el título de plantilla sin rellenar: `# Qué quiero construir — <nombre-del-proyecto>`.
- **Problema:** El `onboarding-reader` escribió en la cabecera del extracto `**Proyecto:** ReciclApp (Recicladora Oriente Verde)`. **"ReciclApp" no aparece en ninguna parte del brief**: el agente inventó un nombre comercial y lo registró como dato del cliente. `ingest-protocol` sí advierte que "plantilla sin rellenar ≠ contenido" y prohíbe **citar** un marcador como si fuera respuesta, pero no contempla el caso de **sustituirlo** por una invención plausible. Un dato fabricado en la cabecera se propaga al `discovery.md` y de ahí al prototipo, donde ya nadie recuerda que nadie lo decidió.
- **Solución / aprendizaje:** Una prohibición redactada sobre un verbo concreto ("no cites") deja libre el resto del espacio de acciones sobre el mismo objeto. Los marcadores sin rellenar necesitan una regla sobre el **campo**, no sobre el verbo: un marcador vivo es un **hueco declarado**, y su valor de salida es `<sin dato en el brief>` o una pregunta para la entrevista.
- **Cómo aplicarlo:** Al redactar una restricción anti-fabricación en un skill, formularla como invariante del campo de salida ("todo valor debe ser trazable a una cita; si no lo es, va como hueco"), no como prohibición de un verbo. Ver T-028.
- **Fecha:** 2026-07-19

### L-006 — La extracción área por área no detecta contradicciones entre áreas
- **Contexto:** Prueba T-027, revisión del `document_extract.md` contra el `client_brief.md`.
- **Problema:** El brief describe en su §5 (camino feliz del cliente) que el registro es *"por email **con validacion de correo** o … **gmail o de apple**"*, y en su §8 (qué NO hacer ahora) excluye explícitamente *"1. Validacion de correo electronico. 2. Tampoco validacion de correo con gmail o con apple"*. El camino feliz arranca con un paso que el propio documento declara fuera de alcance. El reader extrajo **las dos citas correctamente** (en §6 y §9 del extracto) pero marcó ambas áreas `cubierta` y no registró ninguna ambigüedad: nunca cruzó una con otra. Consecuencia en cadena: el interviewer no pregunta (áreas cubiertas), el writer redacta un camino feliz con validación de correo, y el prototipador construye un paso excluido — hueco silencioso detectado recién en el prototipo.
- **Solución / aprendizaje:** El Paso 2 de `ingest-protocol` es un bucle **por área**: para cada área, busca material y clasifica cobertura. Ese diseño detecta bien ambigüedades **locales** (A1–A5 salieron todas correctas, incluida A4 que cruzaba la §10 del brief con el flujo) pero es estructuralmente ciego a las contradicciones **transversales**, porque ninguna iteración ve dos áreas a la vez. Faltaba un paso de cruce explícito después del bucle.
- **Cómo aplicarlo:** Un protocolo de extracción por casilleros necesita una pasada final de **consistencia entre casilleros**, con los cruces de alto riesgo nombrados (camino feliz §6 vs. exclusiones §9; actores §5 vs. §6; Gatekeeper §7 vs. hipótesis §2). Ver T-029.
- **Fecha:** 2026-07-19

### L-007 — Escribir el campo de confirmación antes de pedirla falsea la traza
- **Contexto:** Prueba T-027. El `document_extract.md` quedó escrito con `Confirmado por el humano: sí` y `Estado: cerrado` mientras el agente todavía preguntaba al humano si quería revisarlo.
- **Problema:** El Paso 3 de `ingest-protocol` fija un orden explícito —escribir → presentar resumen → **pedir confirmación de bloque** → marcar `Confirmado: sí` y `cerrado`— y el agente lo colapsó, tomando la confirmación previa de *qué archivo ingerir* como si fuera la confirmación *del contenido resultante*. El artefacto queda declarando una validación humana que no ocurrió: cualquier agente aguas abajo lo lee como material validado. Es la misma familia de L-004 (gate documentado que no se ejecuta), pero aquí el gate **sí** está en el `SKILL.md` y aun así se saltó.
- **Solución / aprendizaje:** Un campo de metadatos que registra un acto humano (`Confirmado por el humano`) es un **registro de evidencia**, no un campo más de la plantilla que se rellena al escribir el documento. Escribirlo en la misma pasada que el contenido invita a rellenarlo por defecto.
- **Cómo aplicarlo:** Los campos que atestiguan un acto humano deben nacer con el valor negativo (`no` / `pendiente`) al crear el artefacto y modificarse **solo** en una escritura posterior y separada, disparada por la respuesta del humano. Ver T-028.
- **Fecha:** 2026-07-19

### L-008 — La tabla de cobertura carece de estado `n/a` y provoca preguntas indebidas
- **Contexto:** Prueba T-027. El reader marcó §3 (tipo de prototipo dominante) y §10 (split por audiencia) como `ausente`.
- **Problema:** Los tres estados disponibles (`cubierta` / `parcial` / `ausente`) no distinguen "el documento no lo dice" de "**no corresponde** que el documento lo diga". §3 la deduce el Descubridor —el propio `ingest-protocol` lo afirma— y §10 es opcional. El reader lo sabía y lo anotó en la columna *Qué falta* (*"corresponde deducirlo al Descubridor, no al cliente"*), pero `interview-protocol` solo consulta el **estado**, y su regla es *ausente → pregunta el área completa*. La aclaración quedó en una columna que el consumidor no lee, y §3 entró en la agenda de entrevista: se le preguntará al cliente algo que por diseño no le toca responder.
- **Solución / aprendizaje:** Cuando un artefacto es contrato entre dos agentes, la información que gobierna la conducta del consumidor debe vivir en el **campo que el consumidor lee**. Prosa aclaratoria en una columna adyacente no es ejecutable. Mismo patrón que L-004, ahora entre dos skills en vez de entre documentación y skill.
- **Cómo aplicarlo:** Añadir el estado `n/a` (no aplica al cliente) a la tabla de cobertura y su regla correspondiente en `interview-protocol` (*n/a → no preguntar*). Al diseñar un artefacto de traspaso, verificar que cada decisión del consumidor se apoye en un campo enumerado, no en texto libre. Ver T-028.
- **Fecha:** 2026-07-19

### L-009 — "Commit por etapa" está en la metodología pero ningún skill de etapa lo implementa
- **Contexto:** Prueba T-027. Tras la ingesta, el usuario notó que no se había hecho ningún commit ni push.
- **Problema:** Dos reglas vinculantes lo exigen —`principles.md:37` (*"Git como registro de estado […] desde el principio debe estar enlazado a un repositorio remoto"*) y `methodology.md:515` §7 (*"**commit por etapa** con prefijo convencional; el push se hace en el cierre de sesión"*)— pero de los siete skills del molde **solo `closing-protocol` toca git** (su Paso 6). `ingest-protocol`, `interview-protocol`, `discovery-protocol` y `prototype-protocol` no mencionan git ni una vez. El `onboarding-reader` no incumplió nada: su skill nunca le pidió commitear. Además, el proyecto de prueba **no era un repo git en absoluto** (`fatal: not a git repository`) y nada en el arranque del estadio lo detecta, así que un proyecto puede recorrer el descubrimiento completo sin control de versiones y sin aviso hasta el cierre.
- **Solución / aprendizaje:** Tercera aparición del patrón de L-004: regla documentada en la capa de método, no implementada en la capa operativa. Se confirma que la divergencia documentación↔ejecución es **sistemática** en este harness, no incidental — merece una verificación de cobertura, no parches caso a caso.
- **Cómo aplicarlo:** Implementar el commit por etapa en los skills de etapa y un bootstrap de repo al inicio del estadio (T-030). Y de forma general: cuando `methodology.md` o `principles.md` impongan una conducta operativa, auditar **todos** los `SKILL.md` que deberían ejecutarla, en vez de asumir cobertura. Ver T-031.
- **Fecha:** 2026-07-19

### L-010 — Editar una capa sin recorrer las demás rompe silenciosamente al consumidor
- **Contexto:** T-031 (auditoría), al implementar G7 (timebox acordado). El primer borrador movió el campo *Timebox acordado* a la cabecera Meta del log de entrevista (`interview_document.md`), separado del registro de Q&A.
- **Problema:** El `onboarding-writer` (y cualquier lector del log) espera encontrar el material trazable en el cuerpo de Q&A, no en la cabecera. Al mover el campo ahí, el writer habría dejado de encontrarlo silenciosamente — un hueco nuevo, generado por la propia corrección, sin que ningún check existente lo detectara. Se descubrió y corrigió en la misma sesión, antes de propagarlo.
- **Solución / aprendizaje:** Es el **mismo patrón exacto** que T-031 audita (regla en una capa, no implementada/consumida en otra) pero autogenerado por el propio equipo al editar el harness. Confirma empíricamente que la divergencia documentación↔ejecución no es solo un defecto heredado: es fácil de reintroducir al tocar una sola capa sin verificar las que dependen de ella.
- **Cómo aplicarlo:** Al añadir o mover un campo en una plantilla/artefacto de traspaso, identificar explícitamente **quién lo consume** (qué otro skill lo lee) y verificar que ese consumidor sigue encontrándolo en el lugar nuevo, antes de dar el cambio por cerrado. No basta con revisar el productor.
- **Fecha:** 2026-07-19

### L-011 — "Cubierta" significa cosas distintas entre `ingest-protocol` y `discovery-protocol` para §7
- **Contexto:** Detectado al revisar T-031/T-033. `ingest-protocol` marca §7 (Gatekeeper) como `cubierta` cuando el brief trae métrica+umbral. Pero `discovery-protocol` Paso 1.6 exige métrica+umbral+**método de medición** para dar el Gatekeeper por completo.
- **Problema:** Un área que el reader entrega como `cubierta` puede llegar corta al writer, que necesita un dato más (el método) que el reader nunca pidió ni marcó como faltante. El estado enumerado `cubierta` no significa lo mismo para los dos skills que lo leen/escriben — mismo defecto de clase que L-008 (información que gobierna la conducta del consumidor no vive en el campo que el consumidor lee), pero aquí entre dos skills que ya usan el mismo campo con semántica distinta.
- **Solución / aprendizaje:** Sin corregir aún; queda registrada para T-041. No se corrigió a ojo dentro de esta sesión para evitar tocar la definición de cobertura sin evidencia de una corrida real que confirme el impacto.
- **Cómo aplicarlo:** Antes de dar una tarea de alineación por cerrada, verificar que el criterio de "completo" para cada estado enumerado sea **idéntico** en el productor y en el consumidor del campo, citando el paso exacto de cada `SKILL.md`. Ver T-041.
- **Fecha:** 2026-07-19

### L-012 — Una regla anti-fabricación correcta al pie de la letra puede fallar su intención
- **Contexto:** Al escribir T-033 (procedimiento de repetición de T-027) se revisó el `client_brief.md` de reciclaje y se notó que "Recicladora Oriente Verde" aparece literalmente en el texto — pero es el **nombre de la empresa cliente**, no el nombre del proyecto/producto a construir (el hueco real que causó L-005).
- **Problema:** Un `onboarding-reader` que aplique la regla anti-fabricación de L-005/T-028 al pie de la letra ("todo valor debe ser trazable a una cita") podría citar literalmente "Recicladora Oriente Verde" como si fuera el nombre del proyecto, porque la cadena de texto sí existe en el brief — y aun así estaría fallando la intención de la regla (evitar que se invente o confunda el dato pedido).
- **Solución / aprendizaje:** La trazabilidad textual (¿la cadena aparece en el documento?) no es suficiente por sí sola; hace falta también que la cita responda a la **pregunta correcta** (¿es el nombre del proyecto o el de otra entidad mencionada?). No se generalizó una regla nueva sin evidencia de una corrida real (NC-1); se documentó como caso de "aprobado con reparo" en `T-027_procedimiento.md`, a vigilar en la próxima repetición.
- **Cómo aplicarlo:** Al revisar la salida de un reader/extractor, no basta con verificar que cada valor tenga una cita de respaldo: verificar también que la cita responda al campo que se le pidió, especialmente cuando el documento nombra varias entidades similares (empresa vs. proyecto vs. producto).
- **Fecha:** 2026-07-19

### L-013 — Condicionar el commit de etapa al gate humano deja sin commit si el humano salta el gate
- **Contexto:** Corrida 2 de T-027, tras implementar T-030 (commit por etapa) en `ingest-protocol`/`discovery-protocol`, condicionado a la confirmación/gate humano.
- **Problema:** Cuando el humano decide saltarse el gate (instrucción legítima y razonable, coherente con D-029), el commit no ocurre nunca y nada lo recupera. La etapa de ingesta se cerró y avanzó a la entrevista sin commit ni repo git: exactamente el defecto que T-030 debía cerrar (L-009), reaparecido por el propio diseño de la corrección.
- **Solución / aprendizaje:** Un protocolo que solo funciona si el humano no toma atajos no es un protocolo. El disparador correcto es la **salida de la etapa**, no la aprobación del contenido.
- **Cómo aplicarlo:** Desacoplar el commit del gate: commitear siempre al salir de la etapa, marcando `[sin confirmar]` en el mensaje si el artefacto quedó en borrador. Ver T-042.
- **Fecha:** 2026-07-19

### L-014 — `interview-protocol` consume un extracto en borrador sin detectarlo
- **Contexto:** Corrida 2 de T-027. El Paso 0 de `interview-protocol` lee la tabla de cobertura de `document_extract.md` para fijar la agenda de la entrevista.
- **Problema:** Nunca comprueba el campo `Estado`/`Confirmado por el humano` del extracto (verificado por grep: no existe tal comprobación). Consumió un extracto permanentemente en `borrador` sin avisar a nadie.
- **Solución / aprendizaje:** No existe un contrato de entrada entre etapas: cada skill asume que su insumo ya está validado, en vez de verificarlo. Misma clase que L-008 (información que gobierna la conducta del consumidor no vive en el campo que el consumidor lee), ahora aplicada al estado de confirmación.
- **Cómo aplicarlo:** Cada skill de etapa debe verificar el `Estado`/`Confirmado` del artefacto que consume y **avisar** (no bloquear — la autoridad es del humano, NC-6) si viene en borrador. Ver T-043.
- **Fecha:** 2026-07-19

### L-015 — El interviewer atribuyó mal la procedencia de un dato: inventó la fuente, no el valor
- **Contexto:** Corrida 2 de T-027. Al preguntar por el nombre del proyecto, el interviewer afirmó que "ReciclApp" venía de una lectura del brief.
- **Problema:** La palabra "ReciclApp" no aparece ni una vez en `client_brief.md`; está en `_context/project.yaml`, que no es insumo declarado de ninguna etapa. Es una variante de L-005 (fabricar un valor), pero más difícil de detectar: aquí se fabricó la **fuente** de un valor real, de forma tranquilizadora ("venía del brief" suena respaldado) en vez de fabricar el valor mismo.
- **Solución / aprendizaje:** La trazabilidad textual de un valor no basta si la atribución de su origen puede mentir; cada dato de salida necesita declarar su procedencia real, verificable, no solo "sonar" verificado.
- **Cómo aplicarlo:** Hacer `project.yaml` insumo declarado desde el Paso 0 de los skills de etapa, distinguiendo metadatos de proyecto (fuente `project.yaml`) de contenido del cliente (fuente brief), y anotar la fuente junto a cada valor de salida. Ver T-044.
- **Fecha:** 2026-07-19

### L-016 — El criterio de aceptación de L-007 es ciego a "nunca se confirmó"
- **Contexto:** `T-027_procedimiento.md` (T-033) escribió el criterio de aceptación de L-007 antes de la corrida 2, contemplando solo el escenario "se confirmó antes de tiempo".
- **Problema:** En la corrida 2 el extracto nunca se confirmó (quedó permanentemente en `Confirmado: no` / `Estado: borrador`) y el criterio escrito dio el caso por bueno, porque no contempla el escenario opuesto: que el gate simplemente no se ejecute nunca.
- **Solución / aprendizaje:** Un criterio de aceptación escrito para un solo lado de un fallo binario (confirmar de más / confirmar de menos) deja pasar el lado no contemplado sin ser detectado.
- **Cómo aplicarlo:** Corregir el criterio de L-007 en `T-027_procedimiento.md` para que "nunca se confirmó" cuente también como fallo. Ver T-046.
- **Fecha:** 2026-07-19
