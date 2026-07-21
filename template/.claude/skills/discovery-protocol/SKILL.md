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

0. **Leer `_context/project.yaml`** — insumo declarado. Es la fuente de los **metadatos** de la Meta del
   `discovery.md` (`Proyecto`, y `Cliente / solicitante` si lo declara). Rige la **regla de procedencia**
   (§0.2 de `methodology.md`): los metadatos salen de aquí; el **contenido** (§1–§10) sale del log y del
   extracto. Las fuentes **no se cruzan**, y lo que ninguna traiga se escribe `<no declarado>` (L-015).
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
4. **Verificar el estado de ambos insumos (contrato de entrada, §5.1 paso 0 de `methodology.md`).**
   Leer `Estado` del log (`en curso` \| `cerrada`), y del extracto `Estado` + `Confirmado por el
   humano`; mirar además si el campo *Extracto documental* del log viene marcado `(sin confirmar)`.
   Todo insumo en borrador o sin confirmar se **declara en la Meta del `discovery.md`** (campo
   *Procedencia de los insumos*) y se **avisa** en el resumen del Paso 2. **No bloquees ni confirmes tú
   nada:** seguir o parar lo decide el humano (NC-6). Un insumo cuyo estado no puedas leer cuenta como
   **no confirmado**.
5. Tomar la plantilla `_templates/discovery_temp.md`: es la **forma** del entregable a producir.
6. Determinar el destino `<DISCOVERY>` = `_prototype/discovery.md`.

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
   **declarar** cuáles existen, faltan o **colapsan** en otro. No forzar tres actores. **Rellenar el
   campo cerrado "Actores a construir en este prototipo"** (L-022): el generador va siempre; añade
   operador/administrador **solo** si el humano los priorizó explícitamente junto al generador para
   esta ronda (algo que dijo en la entrevista, no la mera presencia en la tabla — "presente" ≠ "a
   construir ahora"). Es la única fuente que leerá el Prototipador para decidir alcance; no dejes que
   lo infiera de la prosa de §6.
5. **Camino feliz por actor (§6):** redactar el flujo crítico de cada actor presente; marcar el del
   **generador** como el que construirá primero el Prototipador. Operador/administrador: **bajo demanda**.
   Registrar el **medio/canal de cada actor** (app, web, notebook, CLI…) en la cabecera de su flujo,
   tal como se elicitó; el medio es **por actor**, no del proyecto. Si no se elicitó, declararlo hueco.
6. **Gatekeeper (§7):** formalizar los **tres** componentes — métrica **medible** + umbral + método de
   medición. **Este trío es la definición canónica de §7 "cubierta"** en toda la cadena: `ingest-protocol`
   solo marca §7 `cubierta` si están los tres, e `interview-protocol` elicita los tres. Si cambias este
   criterio, actualiza esos dos en el mismo cambio o volverás a abrir L-011. Si falta alguno, **declara el
   hueco**; no lo completes tú.
7. **Timebox (§8):** se acuerda al abrir la entrevista, así que **no está en el registro de Q&A sino en
   el campo *Timebox acordado* de la cabecera Meta** del log; si dice `sin acordar`, declararlo así en
   §8, no inventar una duración. **Exclusiones explícitas (§9)**; **split (§10)** solo si el log lo
   justifica.

Los **huecos declarados** en el cierre del log se trasladan a `discovery.md` como pendientes marcados
o como exclusiones — según corresponda—, nunca como datos inventados. **Antes de declarar un hueco,
comprueba el extracto:** si el área está marcada *cubierta* ahí, no es un hueco — el material existe y
va al entregable. Tampoco lo es un área marcada **`n/a`**: no se preguntó porque no le corresponde al
cliente (canónicamente §3, que **deduces tú**); tratarla como hueco marcaría pendiente algo que el
entregable sí debe resolver.

---

## Paso 2 — Cerrar y entregar

1. Sustituir todos los `<marcadores>` y borrar los comentarios de guía de la plantilla.
   **Con el archivo escrito, ejecutar ya el commit del Paso 3** (con marcador `[sin confirmar]`): el
   gate se pide sobre un estado confirmado, no sobre un archivo volátil.
2. Presentar un **resumen** del `discovery.md`: actores declarados, camino feliz del generador,
   Gatekeeper y exclusiones; señalar cualquier insuficiencia del log para el camino feliz del generador
   y, si algún insumo vino en borrador o sin confirmar (Paso 0.4), **decirlo aquí explícitamente**: el
   humano va a aprobar sobre esa base y tiene derecho a saberlo antes del gate.
3. **Pedir aprobación explícita al humano (GATE, P5).** El entregable queda en `borrador` hasta que la
   dé. Si pide correcciones, aplicarlas y volver a presentar. **No marques `cerrado` por tu cuenta.**
4. Con la aprobación, marcar el entregable como **cerrado**. Queda listo como **único insumo del
   Prototipador**.

---

## Paso 3 — Commit de etapa

Con el entregable ya **escrito** (Paso 2.1), aplicar `_guideline/git-protocol.md` §2 (bootstrap) y §3
(commit de etapa):

- Etapa: **discovery** → mensaje `docs(prototipo): entregable de descubrimiento`.
- Artefacto confirmado: `<DISCOVERY>`.

**El disparador es la salida de etapa, no el gate.** Confirma en cuanto el `discovery.md` está escrito,
**antes** de presentarlo al humano: así el gate se pide sobre un estado identificable por hash. Mientras
el entregable siga en `borrador`, el mensaje termina en `[sin confirmar]` (§4 de `git-protocol.md`).

Cuando el humano apruebe (Paso 2.4) y marques el entregable como **cerrado**, eso es un cambio de
archivo: **confirma otra vez**, con el mismo mensaje ya **sin** el marcador. El historial distingue así
borrador de aprobado sin que un gate saltado deje la etapa sin punto de retorno.

Si pide correcciones, cada vuelta de corrección confirma igual, con marcador. Reportar hash y rama.
**No hacer `push`.**

---

## Reglas invariantes

- **Autónomo:** insumos = `interview_document.md` (+ `document_extract.md` si existe), **archivos**, no
  diálogo. No entrevistes tú.
- **Cada fuente en su carril (§0.2):** metadatos ← `project.yaml`; contenido §1–§10 ← log + extracto.
  Lo que ninguna fuente traiga se declara `<no declarado>` o pendiente, nunca se rellena (L-015).
- **Verificar los insumos antes de consumirlos:** su estado se comprueba, se declara en *Procedencia de
  los insumos* y se avisa (§5.1 paso 0 de `methodology.md`). Avisar, **no bloquear**: la autoridad para
  seguir con material sin validar es del humano (NC-6, L-014).
- **La etapa cierra con commit, con gate o sin él:** el entregable se persiste en git en cuanto está
  escrito (`_guideline/git-protocol.md`), rotulado `[sin confirmar]` hasta que el humano lo apruebe; la
  aprobación produce un segundo commit sin marcador. Es el único insumo del Prototipador y debe tener
  punto de retorno **aunque el gate se salte** (L-013).
- **Ambos insumos o entregable mutilado:** si existe el extracto, leerlo es **obligatorio**: el log solo
  contiene los huecos.
- **La entrevista manda ante conflicto**, pero la discrepancia se **deja constancia**, no se silencia.
- **Fidelidad:** solo se estructura lo elicitado o citado; lo demás se declara pendiente/excluido (no
  inventar).
- **La taxonomía es una lente (piso, no techo):** clasificar y declarar ausencias/colapsos, no forzar
  tres actores.
- **Ningún gate lo cruza un agente (P5):** aquí el Gatekeeper se **define** (métrica + umbral), no se
  evalúa; su cruce lo decide el humano con evidencia.
- **El cierre del discovery es un gate humano.** Eres el último eslabón antes de que se construya algo:
  un error tuyo se materializa en el prototipo sin que nadie lo revise. `cerrado` lo autoriza el humano.
- **Idioma:** comunicarse en el idioma del proyecto (por defecto, español).
