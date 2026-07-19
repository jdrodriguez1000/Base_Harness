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

## Paso 0 — Cargar contexto, extracto documental y detectar reanudación

1. Leer `_guideline/methodology.md` **§4.3** (taxonomía de actores) y **§5** (arquetipos) para saber
   **qué** elicitar y con qué lente.
2. Tomar el **esqueleto de temas** de `_templates/discovery_temp.md`: sus secciones (§1 objetivo, §2
   hipótesis de valor, §3 tipo de prototipo, §4 stakeholders, §5 actores, §6 camino feliz **+ medio por
   actor**, §7 Gatekeeper, §8 timebox, §9 exclusiones, §10 split) son las **áreas** que la entrevista
   debe cubrir.
3. **Buscar `_prototype/document_extract.md`** (lo produce el
   `onboarding-reader` a partir de `_context/client_brief.*`):
   - **Si existe:** leer su **tabla de cobertura**. Es la que fija tu agenda:
     - área **cubierta** → **NO preguntes**. El cliente ya lo escribió; repreguntarlo le hace sentir que
       no leíste su documento.
     - área **parcial** → pregunta **solo lo indicado en *Qué falta***, no el área entera.
     - área **ausente** → pregunta el área completa, como en el flujo normal.
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
- **Gatekeeper (§7):** elicitar una métrica de éxito **medible** y su umbral.

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

## Reglas invariantes

- **Append-only:** nunca borrar ni reescribir una entrada guardada; a lo sumo **añadir** una aclaración.
- **Persistencia inmediata:** guardar cada Q&A **antes** de la siguiente pregunta (reanudabilidad).
- **Elicitar, no estructurar:** este skill solo produce el log crudo; `discovery.md` es del writer.
- **No repreguntar lo documentado:** si hay `document_extract.md`, las áreas *cubiertas* no se preguntan.
- **No duplicar el extracto en el log:** el material del documento vive en `document_extract.md`; el log
  registra solo lo elicitado por ti. El writer lee **ambos**.
- **Alcance acotado:** suficiente para el camino feliz del generador; respetar timebox (§4.3).
- **No inventar:** lo no respondido se declara como hueco; no se rellena por cuenta propia (NC-1).
- **Idioma:** comunicarse en el idioma del proyecto (por defecto, español).
