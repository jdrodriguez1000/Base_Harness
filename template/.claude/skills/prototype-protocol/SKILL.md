---
name: prototype-protocol
description: >-
  Protocolo de MATERIALIZACIÓN del prototipo desechable. Toma el discovery.md (producido por el
  Descubridor) y construye el camino feliz del actor —empezando por el generador— en el medio de ese
  actor (§6) y con la tecnología más barata que valide la hipótesis. Ramifica por el tipo dominante
  (§3): wireframe/mockup/HTML clicable si domina deseabilidad, o spike/notebook/PoC si domina
  factibilidad. Construye en bucle (escribir→ejecutar→ajustar), desechable (sin tests, sin robustez).
  Es AUTÓNOMO (insumo = archivo, no diálogo). Úsalo cuando exista un discovery.md cerrado o el usuario
  diga "prototipa el camino feliz", "construye el prototipo" o "materializa el mockup". Agnóstico: no
  asume stack, lenguaje ni dominio.
---

# Prototype Protocol — Materialización del prototipo desechable

Objetivo: **materializar** el camino feliz del actor (por defecto el **generador**) en un prototipo
**desechable**, a partir del `discovery.md`. Está **fuera del ciclo de incremento** (§3 de
`methodology.md`): ocurre en el **estadio de Prototipo de alto nivel** (§4). El único insumo es el
`discovery.md` que produjo el Descubridor (skills `interview-protocol` → `discovery-protocol`).

Este skill es **agnóstico al proyecto** y **autónomo**: su insumo es un archivo, no un diálogo. Pero es
**agéntico**: construye en un bucle escribir→ejecutar→observar→ajustar.

> **Regla de oro del prototipo (crítico).** **Desechable y mínimo.** Construyes **solo** el camino feliz
> del **generador**, en el medio de ese actor, con la tecnología **más barata que valide la hipótesis**
> (§2). **Nada** de tests, robustez, manejo de errores, autenticación real ni capas: aquí eso es
> **anti-objetivo** (§4.4/E4). Respetas las **exclusiones §9** al pie de la letra.

---

## Paso 0 — Cargar contexto e insumos

0. **Leer `_context/project.yaml`** — insumo declarado: nombre del proyecto y repositorio. Rige la
   **regla de procedencia** (§0.2 de `methodology.md`): los metadatos salen de aquí; **qué** construir
   sale del `discovery.md`. No tomes decisiones de alcance de `project.yaml` ni metadatos del
   `discovery.md` (L-015).
1. Leer `_guideline/methodology.md` **§4.2** (frontera juicio↔materialización, regla de medio), **§4.3**
   (disciplina de alcance, taxonomía de actores) y **§4.4** (frontera Prototipo→MVP, desechable).
2. Localizar y leer el **`discovery.md`**. **Verificar primero su estado (contrato de entrada, §5.1
   paso 0 de `methodology.md`):** leer `Estado` y *Procedencia de los insumos* de su Meta. Si el
   entregable sigue en `borrador`, o si su procedencia declara insumos sin confirmar, **avisarlo antes
   de construir nada** —el prototipo heredaría material que nadie validó— y dejar constancia en el
   informe de cierre. **No bloquees ni lo cierres tú:** construir igual o esperar lo decide el humano
   (NC-6). Si no puedes leer esos campos, trátalo como **no confirmado**. De él se extrae:
   - **Actores a construir:** leer el **campo cerrado** "Actores a construir en este prototipo" de §5
     (L-022). Construir **exactamente** ese conjunto, ni más ni menos: el generador siempre figura y es
     obligatorio; operador/administrador se construyen **solo si el campo los incluye explícitamente**,
     aunque figuren "presentes" en la tabla de actores — presente ≠ a construir ahora. No asumas
     "solo generador" por tu cuenta ni amplíes el alcance porque la invocación lo sugiera: el
     `discovery.md` es la **única fuente** de esta decisión. Si el campo falta o es ambiguo, trátalo
     como hueco de especificación y **pregunta** (NC-1/NC-6) antes de construir.
   - **Tipo dominante (§3):** deseabilidad o factibilidad → decide *qué* se materializa.
   - **Medio del actor (§6):** app, web, notebook, CLI… → decide *en qué* se materializa.
   - **Hipótesis de valor (§2)** y **Gatekeeper (§7):** qué debe poder validar el prototipo.
   - **Timebox (§8):** tu **presupuesto de construcción** — uno de los dos motivos de cierre (Paso 3).
     Si §8 dice `sin acordar`, **acuérdalo con el humano antes de empezar** (NC-6): es una decisión de
     alcance, no tuya. Si lo prefiere abierto, cerrarás **solo** por camino feliz cubierto.
   - **Exclusiones (§9):** qué queda **fuera**, sin excepción.
3. Determinar el destino `<PROTOTYPE>` = `_prototype/prototype/` (hermana de `discovery.md`). Todo lo
   que construyas vive ahí dentro: el prototipo es **desechable** y no debe mezclarse con el código
   del producto.

> Si falta la **dirección de UX** o el **medio** de un actor, es un hueco de juicio humano (§4.2):
> **pregúntalo** (NC-1/NC-6); no lo inventes.

---

## Paso 1 — Ramificar por tipo dominante (§3)

- **Domina DESEABILIDAD** → materializa un **wireframe / mockup / HTML clicable** del camino feliz del
  generador en su medio. Backend y datos **falsos/simulados**; lo que requiera simulación viva (mago de
  Oz) se **deja indicado** como intervención humana, no se construye. Elige la tecnología **más barata**
  (p. ej. un solo HTML clicable que simula la pantalla del medio declarado).
- **Domina FACTIBILIDAD** → materializa un **spike / notebook / PoC** que ejercita la **hipótesis de
  valor** sobre datos reales o de muestra, **sin robustez**. En DS/ML suele ser un notebook con un
  baseline que mide si la señal existe.

En ambos casos: **solo el camino feliz de los actores declarados a construir** (Paso 0), nada de lo
excluido en §9.

---

## Paso 2 — Construir en bucle (desechable)

Bucle agéntico dentro de `<PROTOTYPE>`:

1. **Escribir** el mínimo necesario para el siguiente paso del camino feliz.
2. **Ejecutar / previsualizar** (correr el spike, abrir el mockup) para observar el comportamiento real.
3. **Ajustar** según lo observado. Repetir hasta cubrir el camino feliz del generador de punta a punta.
4. **Checkpoint cuando la iteración deja algo ejecutable** (`_guideline/git-protocol.md` §3.1):
   confirmar con el mensaje de etapa más `[sin confirmar]`. La unidad es el **estado que corre**, no la
   edición de archivo: así puedes volver a la última versión que funcionaba cuando un ajuste rompa el
   prototipo — que en un bucle de escribir→ejecutar→ajustar pasa constantemente. **Sin `push`** (D-033).

Disciplina durante el bucle:
- **Alcance:** si algo no es el camino feliz del generador ni valida la hipótesis, **no se construye**.
- **Sin capas:** no añadas robustez, tests, manejo de errores ni pulido estético secundario.
- **Aislamiento:** escribe solo bajo `<PROTOTYPE>`; **no** toques `discovery.md` ni `interview_document.md`.

---

## Paso 3 — Feature freeze, informar y ceder el gate

1. **Cerrar** al cubrir el camino feliz del generador **o** al agotar el **timebox** cargado en el
   Paso 0 — lo que ocurra primero. Al cerrar por timebox: **feature freeze** (se congela; las mejoras
   secundarias se posponen). Si el timebox quedó abierto por decisión del humano, el único motivo de
   cierre es el camino feliz cubierto: **no inventes un tope** para justificar el cierre.
2. **Informar** (narrativa, no evidencia §10): qué se construyó, en qué medio, qué parte se simula por
   mago de Oz, y **qué evidencia permite recoger** el prototipo frente al **Gatekeeper (§7)**.
3. **No cruzar el gate (P5):** el paso Prototipo→MVP lo decide el **humano** con la evidencia. El
   prototipo queda como **referencia/demo desechable**, no se copia-pega al MVP (§4.4).

---

## Paso 4 — Commit de etapa

Tras el **feature freeze** y **antes** de ceder el gate al humano, aplicar
`_guideline/git-protocol.md` §2 (bootstrap) y §3 (commit de etapa):

- Etapa: **prototype** → mensaje `feat(prototipo): camino feliz del generador`.
- Artefacto confirmado: `_prototype/prototype/`.

El commit precede al gate porque el humano evalúa **sobre un estado congelado e identificable**: sin
hash, «el prototipo que vi» no es un objeto al que se pueda volver. Reportar hash y rama junto al
informe. **No hacer `push`** y **no** cruzar el gate (P5).

---

## Reglas invariantes

- **Desechable y mínimo:** sin tests, sin robustez, sin capas; lo justo para validar la hipótesis (§4.4).
- **Checkpoint por iteración ejecutable:** el bucle confirma cuando deja algo que corre
  (`git-protocol.md` §3.1), para poder volver a la última versión que funcionaba. **Siempre local:** el
  `push` es del cierre de sesión (D-033).
- **Cada fuente en su carril (§0.2):** metadatos ← `project.yaml`; **qué** construir ← `discovery.md`.
  Un hueco no se rellena con la otra fuente ni con una suposición: se pregunta (L-015, NC-6).
- **Verificar el insumo antes de construir:** `Estado` y *Procedencia de los insumos* del `discovery.md`
  se comprueban y se avisan (§5.1 paso 0 de `methodology.md`). Eres el final de la cadena: lo que aquí
  no se detecte, se materializa en código (L-014).
- **Congelar es confirmar:** el feature freeze cierra con commit (`_guideline/git-protocol.md`) antes de
  ceder el gate; desechable no significa no versionado (L-009).
- **El `discovery.md` declara el conjunto exacto de actores a construir** (§5, campo cerrado, L-022):
  el generador siempre es obligatorio; operador/administrador se construyen únicamente si el campo los
  incluye. Una sola fuente de verdad — no lo decides tú ni lo infieres de §6.
- **Respeta las exclusiones §9:** guarda anti-*scope creep*; nada de lo excluido se construye.
- **El timebox se carga, no se supone:** sale de §8 del `discovery.md` en el Paso 0; si viene
  `sin acordar`, se acuerda con el humano antes de construir. Cerrar alegando un tope que nadie fijó
  es medir contra nada.
- **Medio del actor + tecnología más barata:** materializa en el medio §6, con lo más barato que valide
  la hipótesis; el medio del prototipo ≠ el del producto final.
- **Juicio de UX y mago de Oz son humanos (§4.2):** tú materializas; no decides el producto ni simulas
  en vivo.
- **Ningún gate lo cruza un agente (P5):** el Gatekeeper se **habilita** con el prototipo, no se evalúa.
- **Idioma:** comunicarse en el idioma del proyecto (por defecto, español).
