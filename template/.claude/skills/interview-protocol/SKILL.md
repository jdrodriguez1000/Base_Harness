---
name: interview-protocol
description: >-
  Protocolo de ENTREVISTA de descubrimiento. Conduce un diálogo ACOTADO con el humano/cliente en
  bucle "una pregunta → guardar la respuesta (append) → siguiente", persistiendo cada Q&A en
  interview_document.md (append-only, reanudable). NO estructura ni interpreta: solo elicita y
  registra crudo. El log resultante es el insumo del onboarding-writer (skill discovery-protocol),
  que lo sintetiza en discovery.md. Úsalo al arrancar el estadio de Prototipo o cuando el usuario
  diga "entrevista de descubrimiento", "onboarding del proyecto" o "entrevístame". Agnóstico: no
  asume stack, lenguaje ni dominio.
---

# Interview Protocol — Protocolo de entrevista de descubrimiento

Objetivo: **elicitar y registrar crudo** lo suficiente para arrancar el prototipo. Se conduce una
entrevista con el humano/cliente y se guarda cada pregunta con su respuesta en
`interview_document.md`. Está **fuera del ciclo de incremento** (§3 de `methodology.md`): ocurre en el
arranque del estadio de Prototipo (§4).

Este skill es **agnóstico al proyecto**. Su única salida es el **log crudo**; la síntesis en
`discovery.md` la hace el `onboarding-writer` (skill `discovery-protocol`).

> **Disciplina de alcance (crítico).** Buscas entendimiento **rápido y suficiente** para prototipar el
> camino feliz del **generador**, no un relevamiento exhaustivo. Respeta un timebox y evita el
> cuestionario infinito que lleva a la **parálisis por diseño** (§4.3). Mínima complejidad (E4).

---

## Traza de ejecución (transversal, OBLIGATORIA)

Antes del Paso 0 **abres la traza** (`_trace/trace.md`) y desde ahí **anexas una fila por evento, en el
momento en que ocurre**. El idioma de anexado (crear si no existe, contar la secuencia,
`printf … >>`) es el de `methodology.md` **§7.2**; no lo reimplementes.

| Cuándo | evento | objetivo | detalle |
|---|---|---|---|
| Al arrancar | `start` | — | `invocación #n` |
| Paso 0 | `read` | `_prototype/document_extract.md` | cobertura cargada (o *no existe*) |
| Paso 0 | `ask` | humano | acordar timebox de la entrevista |
| Respuesta | `confirm` | humano | timebox acordado |
| Cada pregunta del bucle | `ask` | humano | `Qn — <tema, una línea>` |
| Cada respuesta | `confirm` | humano | respondida / no sabe / aplazada |
| Cada guardado | `write` | `_prototype/interview_document.md` | `append Qn` |
| Paso 3 | `commit` | `<hash>` | mensaje del commit |
| Al terminar | `close` + `end` | — | motivo de cierre |

> **Una fila `ask` por pregunta REALMENTE formulada.** No anexes la fila al planear la pregunta ni la
> redactes a posteriori al cerrar: es exactamente el fallo de **L-030**, donde una pregunta llegó al log
> con la redacción hecha después y el conteo quedó inflado. La secuencia `ask` → `confirm` → `write`
> repetida es lo que permite contrastar el número de preguntas del log contra las que ocurrieron.

> **Excepción a Single Writer.** `_trace/trace.md` es un log compartido: anexar ahí no viola I4.
> Reescribir filas ya anexadas —tuyas o ajenas— sí.

---

## Paso 0 — Cargar contexto, extracto documental y detectar reanudación

0. **Leer `_context/project.yaml`** — insumo declarado. De ahí, y **solo** de ahí, salen los metadatos
   del proyecto (nombre, descripción) que uses o menciones. Rige la **regla de procedencia** (§0.2 de
   `methodology.md`): si citas un dato al humano, **di de dónde sale y verifícalo antes de decirlo**.
   Afirmar "esto venía del brief" sin haberlo comprobado es fabricar la fuente, aunque el valor sea
   correcto (L-015). Si el metadato no está, es `<no declarado>`: **pregúntalo**, no lo deduzcas.
1. Leer `_guideline/methodology.md` **§4.3** (taxonomía de actores) y **§5** (arquetipos) para saber
   **qué** elicitar y con qué lente.
2. Tomar el **esqueleto de temas** de `_templates/discovery_temp.md`: sus secciones (§1 objetivo, §2
   hipótesis de valor, §3 tipo de prototipo, §4 stakeholders, §5 actores, §6 camino feliz **+ medio por
   actor**, §7 Gatekeeper, §8 timebox, §9 exclusiones, §10 split) son las **áreas** que la entrevista
   debe cubrir.
3. **Buscar `_prototype/document_extract.md`** (lo produce el
   `onboarding-reader` a partir de `_context/client_brief.*`):
   - **Si existe: verificar primero su estado (contrato de entrada, §5.1 paso 0 de `methodology.md`).**
     Leer en su cabecera `Estado` y `Confirmado por el humano`. Si está en `borrador` o `Confirmado por
     el humano: no`, **avísalo antes de la primera pregunta** —«el extracto que fija mi agenda no está
     confirmado; las áreas que no pregunte salen de material sin validar»— y regístralo en el campo
     *Extracto documental* de la cabecera del log (p. ej. `<ruta> (sin confirmar)`). **No bloquees ni
     lo confirmes tú:** seguir o parar lo decide el humano (NC-6). Si no logras leer esos campos,
     trátalo como **no confirmado**.
   - **Si existe:** leer su **tabla de cobertura**. Es la que fija tu agenda:
     - área **cubierta** → **NO preguntes**. El cliente ya lo escribió; repreguntarlo le hace sentir que
       no leíste su documento.
     - área **parcial** → pregunta **solo lo indicado en *Qué falta***, no el área entera.
     - área **ausente** → pregunta el área completa, como en el flujo normal.
     - área **n/a** → **NO preguntes**: no es del cliente por diseño (canónicamente §3, el tipo de
       prototipo, que deduce el Descubridor). Preguntarla le pide al cliente una decisión que no le
       toca y quema timebox. Su *"Qué falta"* explica por qué no aplica.
   - Leer también sus **Ambigüedades detectadas**: cada una es una **pregunta obligatoria** de tu agenda
     (el reader las dejó sin resolver a propósito, para que las resuelva el humano).
   - **Si no existe:** flujo por defecto — la entrevista cubre **todas** las áreas §1–§9.
4. Tomar el **formato de registro** de `_templates/interview_temp.md`.
5. Determinar el destino `<INTERVIEW>` = `_prototype/interview_document.md` (crear `_prototype/` si no
   existe: sin documento del cliente, eres el primer agente del estadio).
   - **Si ya existe** un `<INTERVIEW>` en estado `en curso`: leerlo, ver qué áreas quedaron cubiertas
     y **reanudar por la primera pregunta pendiente**. No repreguntar lo ya respondido.
   - **Si no existe:** copiar `interview_temp.md` a `<INTERVIEW>` y rellenar la cabecera (Meta),
     incluyendo el campo *Extracto documental* (ruta del `document_extract.md` o "ninguno").
6. **Acordar el timebox con el humano** (§4.3) y registrarlo en *Timebox acordado* de la cabecera.
   Es tu **primera pregunta**, antes del bucle: pregunta cuánto tiempo/cuántas preguntas está
   dispuesto a dedicar y anota lo que responda. Esa respuesta cubre además el área **§8**, así que
   **no la vuelvas a preguntar** en el bucle.
   - **Si reanudas** una entrevista `en curso`, el timebox ya está en la cabecera: **léelo, no lo
     renegocies**.
   - Si el humano no quiere fijar uno, registrar `sin acordar` y decirle que entonces el cierre lo
     propondrás **solo** por suficiencia (camino feliz del generador cubierto), no por tiempo.

> **Un tope que nadie acordó no es un tope.** §4.3 define el timebox como una **duración tope
> acordada**, y tanto tu cierre (Paso 2) como el del Prototipador dependen de él. Si nadie lo fija, el
> agente que dice "cerrar al agotar el timebox" está midiendo contra un número inventado o contra
> ninguno — y el cuestionario infinito que §4.3 quiere evitar vuelve por la puerta de atrás. Fijarlo
> es barato: una pregunta al principio.

> **No copies el extracto al log.** El material del documento **vive en `document_extract.md`** y el
> `onboarding-writer` lo lee de ahí. Tu log registra **solo lo que tú elicitaste**. Duplicarlo crearía
> dos copias que pueden divergir, y le atribuiría al humano respuestas que no dio.

---

## Paso 1 — Bucle de entrevista (una a una, guardando siempre)

Recorrer las áreas **pendientes** en orden razonable (típicamente §1 → §9; §10 solo si aplica).
"Pendientes" = todas, si no hay `document_extract.md`; o solo las **parciales/ausentes** más las
**ambigüedades**, si lo hay. Para **cada** pregunta:

1. **Formular UNA pregunta** al humano, marcando a qué área (§n) corresponde.
2. **Esperar la respuesta.**
3. **Guardar de inmediato** la entrada `Qk · área · P/R` en `<INTERVIEW>` (**append**), antes de
   pasar a la siguiente. Este guardado por-respuesta es lo que hace la entrevista **reanudable**.
4. Si una respuesta abre un hueco relevante, la **siguiente** pregunta lo indaga; no lo rellenes tú.
5. **Checkpoint al cerrar un bloque** (`_guideline/git-protocol.md` §3.1): terminada un área o un bloque
   de preguntas —y **siempre** si la entrevista se interrumpe—, confirmar el log con el mensaje de etapa
   más `[sin confirmar]`. **No** confirmes por cada Q&A: el guardado del punto 3 ya te hace reanudable
   dentro del bloque, y cien commits de una línea vuelven el historial ilegible. **Los checkpoints no se
   empujan** — el `push` es del cierre de sesión (D-033).

Guías de contenido (para elegir qué preguntar, no para interpretar):
- **Actores (§5):** preguntar por los tres arquetipos —**Generador**, **Operador**, **Administrador**—
  aunque la respuesta sea que alguno falta o colapsa en otro. Registrar la respuesta tal cual; **no**
  clasifiques tú. *Con extracto:* si §5 quedó **parcial**, pregunta solo por los arquetipos que el
  documento no cubre; el caso típico es que el brief nombre usuarios pero no deje claro **quién origina
  el valor** → esa es tu pregunta.
- **Camino feliz (§6):** priorizar el del **generador** (es el que el prototipo construye primero).
- **Medio/canal por actor (§6):** preguntar **por dónde interactúa cada actor** (app, web, notebook,
  CLI…). Es una decisión de producto del cliente; el medio es **por actor**, no del proyecto. Registrar
  la respuesta; no la decidas tú.
- **Gatekeeper (§7):** elicitar los **tres** componentes —métrica de éxito **medible**, su **umbral** y
  el **método de medición** (cómo se mide, con quién o sobre qué)—. Son los que `discovery-protocol`
  (Paso 1.6) necesita para formalizarlo: si te quedas en métrica+umbral, el hueco aparece al final de la
  cadena, cuando el cliente ya no está (L-011). Elicitar los tres, no formalizarlos: eso es del writer.

> **No interpretes.** Tu salida es el diálogo transcrito. Meter actores en la taxonomía, redactar el
> camino feliz o formalizar el Gatekeeper es trabajo del `onboarding-writer`.

---

## Paso 2 — Cerrar la entrevista

1. **Proponer** el cierre cuando el entendimiento sea **suficiente para arrancar** (camino feliz del
   generador cubierto) o se agote el **timebox** — lo que ocurra primero. El humano está en la
   conversación: dile qué áreas quedarían sin cubrir y **espera su OK**. Si quiere seguir, sigue.
2. Rellenar la sección **Cierre** de `<INTERVIEW>`: motivo de cierre y **huecos declarados** (áreas no
   cubiertas, para que el writer las marque como pendientes/exclusiones).
   > **Con extracto:** un hueco es un área que **ni el documento ni la entrevista** cubren. Las áreas
   > que quedaron cubiertas por el `document_extract.md` **no son huecos** aunque no aparezcan en tu
   > log — el writer las leerá del extracto. Declararlas hueco haría que el writer las excluyera del
   > `discovery.md` teniendo el material a mano.
3. Cambiar `Estado` a **cerrada**. El `interview_document.md` queda listo como insumo del
   `onboarding-writer`.

---

## Paso 3 — Commit de etapa

Aplicar `_guideline/git-protocol.md` §2 (bootstrap) y §3 (commit de etapa):

- Etapa: **interview** → mensaje `docs(prototipo): log de entrevista de descubrimiento`.
- Artefacto confirmado: `<INTERVIEW>`.

La entrevista es **reanudable**: si se cierra en varias sesiones, **cada tramo confirma** al
interrumpirse, con el mismo mensaje. Un log que solo se confirma al final pierde en un fallo todo lo
elicitado, que es justo lo que el append-only quiere evitar. **No hacer `push`.**

---

## Reglas invariantes

- **Declarar la procedencia, y verificarla antes de declararla (§0.2):** al mencionarle un dato al
  humano, di de qué archivo sale y **compruébalo primero**. Inventar la fuente de un valor correcto es
  tan grave como inventar el valor, y mucho más difícil de detectar (L-015).
- **Verificar el insumo antes de consumirlo:** el estado del `document_extract.md` se comprueba y se
  avisa si viene en borrador o sin confirmar (§5.1 paso 0 de `methodology.md`). Un extracto sin validar
  gobierna igual tu agenda —decide qué **no** preguntas—, así que el humano debe saberlo (L-014).
- **Checkpoint por bloque, nunca por Q&A:** el log confirma al cerrar un área o bloque y al interrumpirse
  (`git-protocol.md` §3.1). **Siempre local:** el `push` es del cierre de sesión (D-033).
- **Append-only:** nunca borrar ni reescribir una entrada guardada; a lo sumo **añadir** una aclaración.
- **Cada tramo confirma:** al cerrar o interrumpir la entrevista se hace commit del log
  (`_guideline/git-protocol.md`); la persistencia inmediata en disco no basta si el trabajo nunca entra
  a git (L-009).
- **Persistencia inmediata:** guardar cada Q&A **antes** de la siguiente pregunta (reanudabilidad).
- **Elicitar, no estructurar:** este skill solo produce el log crudo; `discovery.md` es del writer.
- **No repreguntar lo documentado:** si hay `document_extract.md`, las áreas *cubiertas* no se preguntan.
- **Las áreas `n/a` tampoco se preguntan:** no son del cliente por diseño (canónicamente §3).
- **No duplicar el extracto en el log:** el material del documento vive en `document_extract.md`; el log
  registra solo lo elicitado por ti. El writer lee **ambos**.
- **Alcance acotado:** suficiente para el camino feliz del generador; respetar el timebox (§4.3).
- **El timebox se acuerda, no se supone:** se fija con el humano en el Paso 0 y se registra en la
  cabecera; al reanudar se lee de ahí. Sin acuerdo, el cierre se propone por suficiencia, no por tiempo.
- **No inventar:** lo no respondido se declara como hueco; no se rellena por cuenta propia (NC-1).
- **Idioma:** comunicarse en el idioma del proyecto (por defecto, español).
