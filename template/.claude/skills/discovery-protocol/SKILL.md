---
name: discovery-protocol
description: >-
  Protocolo de REDACCIÓN del entregable de descubrimiento. Toma el log crudo interview_document.md
  (producido por la entrevista, skill interview-protocol) y —si existe— document_extract.md (extracto
  del documento del cliente, skill ingest-protocol), y los sintetiza JUNTOS en discovery.md estructurado
  según _templates/discovery_temp.md: clasifica actores en la taxonomía Generador/Operador/
  Administrador, extrae el camino feliz del generador, fija el Gatekeeper y declara exclusiones. Es un
  procedimiento AUTÓNOMO (insumos = archivos, no diálogo). discovery.md es el único insumo del
  Prototipador. Úsalo cuando exista un interview_document.md cerrado o el usuario diga "redacta el
  discovery" o "genera el entregable de descubrimiento". Agnóstico: no asume stack, lenguaje ni dominio.
---

# Discovery Protocol — Redacción del entregable de descubrimiento

Objetivo: **sintetizar** lo recogido en el descubrimiento —el log crudo de la entrevista
(`interview_document.md`) y, si el cliente entregó documentación, el extracto de su documento
(`document_extract.md`)— en el **entregable de descubrimiento** (`discovery.md`), único insumo del
**Prototipador**. Está **fuera del ciclo de incremento** (§3 de `methodology.md`): ocurre en el arranque
del estadio de Prototipo (§4).

Este skill es **agnóstico al proyecto** y **autónomo**: sus insumos son archivos, no un diálogo con el
humano. Antes actuaron el `onboarding-reader` (skill `ingest-protocol`, solo si había documento) y el
`onboarding-interviewer` (skill `interview-protocol`).

> **No inventes.** Solo estructuras lo que el log contiene. Lo no elicitado se declara **pendiente** o
> se mueve a **exclusiones**; nunca se rellena por cuenta propia (NC-1). Si el log es insuficiente para
> el camino feliz del **generador**, señálalo explícitamente.

---

## Paso 0 — Cargar insumos

Puedes tener **uno o dos** insumos, según si el cliente entregó documentación:

1. Localizar y leer el log **`interview_document.md`** (debería estar en estado `cerrada`; si sigue
   `en curso`, avisar que la síntesis será parcial).
2. Localizar y leer **`document_extract.md`** si existe (lo produjo el `onboarding-reader` a partir de
   `_context/client_brief.*`). **Es tu segundo insumo, no un anexo opcional:** cuando existe, el log de
   la entrevista contiene **solo los huecos** que el documento no cubría — todo lo demás está en el
   extracto. Sintetizar solo con el log produciría un `discovery.md` mutilado.
   - Su **tabla de cobertura** te dice qué área viene de dónde; sus **extractos** son citas textuales
     del documento con localización.
   - Si el extracto **no** existe, el log es tu insumo único (flujo por defecto).
3. Leer `_guideline/methodology.md` **§4.3** (taxonomía de actores, Gatekeeper, exclusiones) y **§5**
   (arquetipos) — la lente para interpretar ambos insumos.
4. Tomar la plantilla `_templates/discovery_temp.md`: es la **forma** del entregable a producir.
5. Determinar el destino `<DISCOVERY>` = `discovery.md` en la carpeta del estadio de prototipo.

> **Precedencia ante conflicto.** Si el documento y la entrevista se contradicen, **manda la
> entrevista**: es posterior y el humano habló con conocimiento del documento. **Pero no lo silencies**
> — deja constancia de la discrepancia en el `discovery.md` (nota en el área afectada). Una
> contradicción entre lo que el cliente escribió y lo que dijo es información valiosa, no ruido (NC-1).

---

## Paso 1 — Sintetizar el log en el entregable

Copiar `_templates/discovery_temp.md` a `<DISCOVERY>` y **rellenar cada sección** interpretando los
insumos. El campo `área (§n)` de cada entrada del log indica a qué sección pertenece cada respuesta; en
el extracto, las áreas §1–§10 ya vienen rotuladas. Para cada sección, **funde ambas fuentes**: lo citado
del documento + lo elicitado en la entrevista.

1. **Objetivo (§1)** e **hipótesis de valor (§2):** redactar a partir de las respuestas.
2. **Tipo de prototipo (§3):** deducir si domina deseabilidad o factibilidad según lo elicitado.
3. **Stakeholders (§4).**
4. **Actores (§5):** **clasificar** cada actor mencionado en Generador/Operador/Administrador y
   **declarar** cuáles existen, faltan o **colapsan** en otro. No forzar tres actores.
5. **Camino feliz por actor (§6):** redactar el flujo crítico de cada actor presente; marcar el del
   **generador** como el que construirá primero el Prototipador. Operador/administrador: **bajo demanda**.
   Registrar el **medio/canal de cada actor** (app, web, notebook, CLI…) en la cabecera de su flujo,
   tal como se elicitó; el medio es **por actor**, no del proyecto. Si no se elicitó, declararlo hueco.
6. **Gatekeeper (§7):** formalizar como métrica **medible** + umbral + método.
7. **Timebox (§8)** y **exclusiones explícitas (§9)**; **split (§10)** solo si el log lo justifica.

Los **huecos declarados** en el cierre del log se trasladan a `discovery.md` como pendientes marcados
o como exclusiones — según corresponda—, nunca como datos inventados. **Antes de declarar un hueco,
comprueba el extracto:** si el área está marcada *cubierta* ahí, no es un hueco — el material existe y
va al entregable.

---

## Paso 2 — Cerrar y entregar

1. Sustituir todos los `<marcadores>` y borrar los comentarios de guía de la plantilla.
2. Presentar un **resumen** del `discovery.md`: actores declarados, camino feliz del generador,
   Gatekeeper y exclusiones; señalar cualquier insuficiencia del log para el camino feliz del generador.
3. Marcar el entregable como **cerrado**. Queda listo como **único insumo del Prototipador**.

---

## Reglas invariantes

- **Autónomo:** insumos = `interview_document.md` (+ `document_extract.md` si existe), **archivos**, no
  diálogo. No entrevistes tú.
- **Ambos insumos o entregable mutilado:** si existe el extracto, leerlo es **obligatorio**: el log solo
  contiene los huecos.
- **La entrevista manda ante conflicto**, pero la discrepancia se **deja constancia**, no se silencia.
- **Fidelidad:** solo se estructura lo elicitado o citado; lo demás se declara pendiente/excluido (no
  inventar).
- **La taxonomía es una lente (piso, no techo):** clasificar y declarar ausencias/colapsos, no forzar
  tres actores.
- **Ningún gate lo cruza un agente (P5):** aquí el Gatekeeper se **define** (métrica + umbral), no se
  evalúa; su cruce lo decide el humano con evidencia.
- **Idioma:** comunicarse en el idioma del proyecto (por defecto, español).
