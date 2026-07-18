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

## Paso 0 — Cargar contexto y detectar reanudación

1. Leer `_guideline/methodology.md` **§4.3** (taxonomía de actores) y **§5** (arquetipos) para saber
   **qué** elicitar y con qué lente.
2. Tomar el **esqueleto de temas** de `_templates/discovery_temp.md`: sus secciones (§1 objetivo, §2
   hipótesis de valor, §3 tipo de prototipo, §4 stakeholders, §5 actores, §6 camino feliz **+ medio por
   actor**, §7 Gatekeeper, §8 timebox, §9 exclusiones, §10 split) son las **áreas** que la entrevista
   debe cubrir.
3. Tomar el **formato de registro** de `_templates/interview_temp.md`.
4. Determinar el destino `<INTERVIEW>` = `interview_document.md` en la carpeta del estadio de prototipo.
   - **Si ya existe** un `<INTERVIEW>` en estado `en curso`: leerlo, ver qué áreas quedaron cubiertas
     y **reanudar por la primera pregunta pendiente**. No repreguntar lo ya respondido.
   - **Si no existe:** copiar `interview_temp.md` a `<INTERVIEW>` y rellenar la cabecera (Meta).

---

## Paso 1 — Bucle de entrevista (una a una, guardando siempre)

Recorrer las áreas del esqueleto en orden razonable (típicamente §1 → §9; §10 solo si aplica).
Para **cada** pregunta:

1. **Formular UNA pregunta** al humano, marcando a qué área (§n) corresponde.
2. **Esperar la respuesta.**
3. **Guardar de inmediato** la entrada `Qk · área · P/R` en `<INTERVIEW>` (**append**), antes de
   pasar a la siguiente. Este guardado por-respuesta es lo que hace la entrevista **reanudable**.
4. Si una respuesta abre un hueco relevante, la **siguiente** pregunta lo indaga; no lo rellenes tú.

Guías de contenido (para elegir qué preguntar, no para interpretar):
- **Actores (§5):** preguntar **siempre** por los tres arquetipos —**Generador**, **Operador**,
  **Administrador**— aunque la respuesta sea que alguno falta o colapsa en otro. Registrar la respuesta
  tal cual; **no** clasifiques tú.
- **Camino feliz (§6):** priorizar el del **generador** (es el que el prototipo construye primero).
- **Medio/canal por actor (§6):** preguntar **por dónde interactúa cada actor** (app, web, notebook,
  CLI…). Es una decisión de producto del cliente; el medio es **por actor**, no del proyecto. Registrar
  la respuesta; no la decidas tú.
- **Gatekeeper (§7):** elicitar una métrica de éxito **medible** y su umbral.

> **No interpretes.** Tu salida es el diálogo transcrito. Meter actores en la taxonomía, redactar el
> camino feliz o formalizar el Gatekeeper es trabajo del `onboarding-writer`.

---

## Paso 2 — Cerrar la entrevista

1. Cerrar cuando el entendimiento sea **suficiente para arrancar** (camino feliz del generador cubierto)
   o se agote el **timebox** — lo que ocurra primero.
2. Rellenar la sección **Cierre** de `<INTERVIEW>`: motivo de cierre y **huecos declarados** (áreas no
   cubiertas, para que el writer las marque como pendientes/exclusiones).
3. Cambiar `Estado` a **cerrada**. El `interview_document.md` queda listo como insumo del
   `onboarding-writer`.

---

## Reglas invariantes

- **Append-only:** nunca borrar ni reescribir una entrada guardada; a lo sumo **añadir** una aclaración.
- **Persistencia inmediata:** guardar cada Q&A **antes** de la siguiente pregunta (reanudabilidad).
- **Elicitar, no estructurar:** este skill solo produce el log crudo; `discovery.md` es del writer.
- **Alcance acotado:** suficiente para el camino feliz del generador; respetar timebox (§4.3).
- **No inventar:** lo no respondido se declara como hueco; no se rellena por cuenta propia (NC-1).
- **Idioma:** comunicarse en el idioma del proyecto (por defecto, español).
