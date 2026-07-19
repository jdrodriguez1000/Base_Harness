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

1. Leer `_guideline/methodology.md` **§4.2** (frontera juicio↔materialización, regla de medio), **§4.3**
   (disciplina de alcance, taxonomía de actores) y **§4.4** (frontera Prototipo→MVP, desechable).
2. Localizar y leer el **`discovery.md`** (debería estar `cerrado`; si sigue `borrador`, avisar que la
   materialización será parcial). De él se extrae:
   - **Actor a construir:** por defecto el **generador** (§5/§6). Operador/administrador solo si la
     invocación lo pide explícitamente (**bajo demanda**, §4.3).
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

En ambos casos: **solo el camino feliz del generador**, nada de lo excluido en §9.

---

## Paso 2 — Construir en bucle (desechable)

Bucle agéntico dentro de `<PROTOTYPE>`:

1. **Escribir** el mínimo necesario para el siguiente paso del camino feliz.
2. **Ejecutar / previsualizar** (correr el spike, abrir el mockup) para observar el comportamiento real.
3. **Ajustar** según lo observado. Repetir hasta cubrir el camino feliz del generador de punta a punta.

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

## Reglas invariantes

- **Desechable y mínimo:** sin tests, sin robustez, sin capas; lo justo para validar la hipótesis (§4.4).
- **Solo el generador:** operador/administrador son bajo demanda (§4.3); no en secuencia inmediata.
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
