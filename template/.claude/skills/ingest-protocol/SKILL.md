---
name: ingest-protocol
description: >-
  Protocolo de INGESTA del documento del cliente. Busca _context/client_brief.* (el documento con que
  el cliente describe lo que quiere construir), y si existe extrae CITAS TEXTUALES mapeadas a las áreas
  §1–§10 del descubrimiento, produciendo document_extract.md con una tabla de cobertura (cubierta /
  parcial / ausente / n/a). NO entrevista ni estructura: solo cita y clasifica cobertura, para que el
  onboarding-interviewer pregunte SOLO los huecos y el onboarding-writer disponga del material del
  documento al redactar discovery.md. Si no existe client_brief.*, no produce nada y la entrevista se
  conduce completa. Úsalo al arrancar el estadio de Prototipo, antes de la entrevista, o cuando el
  usuario diga "hay un documento del cliente", "lee el brief" o "ingiere la documentación". Agnóstico:
  no asume stack, lenguaje ni dominio.
---

# Ingest Protocol — Protocolo de ingesta del documento del cliente

Objetivo: **aprovechar lo que el cliente ya escribió** para no repreguntarlo. Cuando el cliente entrega
un documento describiendo la aplicación que quiere, este protocolo lo lee y produce
`document_extract.md`: **citas textuales** mapeadas a las áreas del descubrimiento más una **tabla de
cobertura** que dice qué queda por preguntar.

Está **fuera del ciclo de incremento** (§3 de `methodology.md`): es el **primer paso** del estadio de
Prototipo (§4), **antes** de la entrevista. Este skill es **agnóstico al proyecto**.

> **Ruta condicional.** Si no existe `_context/client_brief.*`, este protocolo **no produce artefacto**
> y el estadio sigue por su camino por defecto: entrevista completa (`interview-protocol`). La ausencia
> de documento **no es un error**: es el caso normal.

> **Cita, no interpretes (crítico).** Tu salida son **extractos textuales**. Clasificar actores en la
> taxonomía, redactar el camino feliz o formalizar el Gatekeeper es trabajo del `onboarding-writer`. La
> única inferencia que te corresponde es **binaria**: *¿esta área tiene material en el documento?*

---

## Paso 0 — Localizar el documento

1. Buscar en `_context/` un archivo `client_brief.*` (cualquier extensión: `.md`, `.pdf`, `.docx`,
   `.txt`…). El nombre es **convención fija**; la extensión es libre para no imponerle formato al cliente.
2. **Si no existe:** informar *"no hay documento del cliente; se conducirá la entrevista completa"* y
   **terminar** sin escribir nada. No inventes un extracto vacío. Si el humano prefiere escribir un
   brief antes de entrevistarse, la plantilla es `_templates/client_brief_temp.md` → se copia a
   `_context/client_brief.md`; ofrécesela, pero **no la rellenes tú** (el brief es del cliente).
3. **Si existe:** informar al humano **qué archivo encontraste** (ruta, formato, tamaño/extensión) y
   **pedir confirmación** de que es el documento a ingerir antes de leerlo (NC-6: nada de ingerir en
   silencio un archivo equivocado).
4. **Si hay varios candidatos** (`client_brief.md` y `client_brief.pdf`, p. ej.): **no elijas tú** —
   preséntalos y pide al humano que indique cuál.
5. **Si el formato no es legible** con las herramientas disponibles (p. ej. un PDF escaneado sin capa de
   texto): decirlo explícitamente y ofrecer al humano convertirlo o conducir la entrevista completa. **No
   adivines** el contenido.

---

## Paso 1 — Cargar el marco de extracción

1. Leer `_guideline/methodology.md` **§4.3** (taxonomía de actores, Gatekeeper, exclusiones) y **§5**
   (arquetipos): la **lente** para saber qué es relevante.
2. Tomar de `_templates/discovery_temp.md` el **esqueleto de áreas** §1–§10 — son los casilleros a los
   que mapear lo que diga el documento.
3. Tomar el **formato de salida** de `_templates/document_extract_temp.md`.
4. Determinar el destino `<EXTRACT>` = `_prototype/document_extract.md` (junto a
   `interview_document.md` y `discovery.md`). Crear `_prototype/` si no existe: eres el primer agente
   del estadio y por tanto quien la inaugura.

---

## Paso 2 — Extraer por áreas

Leer el documento **completo** una vez antes de escribir nada. Después, para **cada** área §1–§10:

1. Localizar en el documento el material que alimenta esa área.
2. Copiar la **cita textual** (entre comillas) con su **localización** (página, sección, epígrafe), para
   que el writer pueda trazar cada dato del `discovery.md` hasta el brief.
3. Marcar el **estado de cobertura** del área:
   - **cubierta** — hay material suficiente; el interviewer **no** preguntará.
   - **parcial** — hay material incompleto; detallar en *"Qué falta"* qué debe preguntar el interviewer.
   - **ausente** — el documento no dice nada **y debería decirlo**; el interviewer preguntará el área
     completa.
   - **n/a** — el área **no se le pide al cliente**: no es suya por diseño. El interviewer **no**
     preguntará. Anotar en *"Qué falta"* **por qué** no aplica.

> **`n/a` no es un atajo (crítico).** `ausente` y `n/a` suprimen o disparan preguntas en direcciones
> opuestas, así que confundirlos es caro: marcar `n/a` un área que el cliente sí debía responder mete
> un **hueco silencioso** en el `discovery.md`, exactamente lo que el sesgo hacia el hueco evita.
> `n/a` **no es un juicio discrecional tuyo**: se reserva a las áreas que por diseño no provienen del
> cliente. El caso canónico es **§3 (tipo de prototipo dominante)**, que **deduce el Descubridor**, no
> el cliente. **§10 (split)** es `n/a` cuando el proyecto no lo justifica. Cualquier otra área marcada
> `n/a` exige justificación explícita en *"Qué falta"*; ante la duda entre `n/a` y `ausente`, marca
> **`ausente`** (NC-1).

> **Sesgo deliberado hacia el hueco.** Ante la duda, marca **parcial** o **ausente**. Repreguntar de más
> cuesta una pregunta; dar por cubierta un área que no lo está mete un **hueco silencioso** en el
> `discovery.md` que nadie detectará hasta el prototipo (NC-1).

> **Plantilla sin rellenar ≠ contenido.** Si el brief se escribió sobre
> `_templates/client_brief_temp.md`, puede llegar con `<marcadores>` intactos, títulos vacíos o
> comentarios `<!-- -->` de la plantilla. Nada de eso es material del cliente: el área va **ausente**.
> Citar un marcador como si fuera una respuesta es fabricar evidencia.

> **Ningún campo de salida se rellena por reconstrucción (crítico).** La regla anterior cubre las
> **citas**; esta cubre **todo campo de `<EXTRACT>`**, incluidos los de **Meta** —`Proyecto`,
> `Documento origen`, `Formato`—. Cada campo se rellena **solo** con lo que el documento dice
> **literalmente**. Si el documento no lo dice, el campo va `<no declarado>`; **nunca** un valor
> plausible deducido del contenido.
>
> El caso que hay que evitar es sutil: el brief llega con su título en `<nombre-del-proyecto>` sin
> rellenar y el tema deja obvio cómo se "debería" llamar la aplicación. Inventarlo ahí —aunque acierte—
> es **fabricar un dato**: nadie aguas abajo puede distinguir ese nombre de uno que el cliente escribió,
> y el `discovery.md` lo hereda como si fuera suyo. Un `<no declarado>` es un hueco **visible**, que el
> interviewer puede preguntar; un nombre inventado es un hueco **invisible** (NC-1/NC-6).

> **El brief no sigue el orden del discovery.** Sus secciones 1–10 mapean a las áreas §1–§10 pero
> **no una a una** (p. ej. su sección 4 alimenta §5, y §3 —tipo de prototipo— no se pide al cliente:
> lo deduce el Descubridor). Mapea por **contenido**, no por número. Y si el documento no usó la
> plantilla, mapea igual: el cliente escribe como quiere.

Guías por área (para localizar, no para interpretar):
- **Actores (§5):** los documentos de cliente rara vez usan la taxonomía Generador/Operador/
  Administrador. Cita **a quién menciona el documento** tal cual ("el vendedor", "el supervisor"); **no**
  los clasifiques —eso es del writer— y **no** des §5 por cubierta solo porque aparezcan usuarios: si no
  se distingue quién **origina el valor**, es **parcial**.
- **Camino feliz y medio (§6):** el medio (app, web, notebook, CLI…) es **por actor**. Si el documento
  fija el medio de unos actores y no de otros, es **parcial**.
- **Gatekeeper (§7):** un objetivo comercial vago ("mejorar la productividad") **no** es un Gatekeeper.
  Solo cuenta como cubierta si hay **métrica + umbral**; si no, **parcial** o **ausente**.
- **Exclusiones (§9):** cuenta lo que el documento declara fuera de alcance explícitamente.

**Ambigüedades:** cuando el documento diga algo contradictorio, vago o de doble lectura, **no lo
resuelvas**: regístralo en la sección *Ambigüedades detectadas* para que el interviewer lo pregunte.

**Fuera de alcance:** el material que no mapea a ninguna área (presupuesto, cláusulas, calendario
comercial) se lista en su sección, para dejar constancia de que se descartó **conscientemente**.

---

## Paso 3 — Pasada de consistencia **entre** áreas

El bucle del Paso 2 recorre las áreas **una por una**, y por construcción es **ciego a las
contradicciones transversales**: cada cita puede ser correcta en su casillero y aun así chocar con la
de otro. Un documento que promete algo en el camino feliz y lo excluye tres páginas después queda
perfectamente extraído y perfectamente contradictorio. Esta pasada existe para cazar eso.

Cuando termines de extraer **todas** las áreas —y **antes** de escribir nada—, releer el conjunto de
extractos como un solo cuerpo y contrastar al menos estos **cruces de alto riesgo**:

| Cruce | Qué buscar |
|---|---|
| **§6 camino feliz ↔ §9 exclusiones** | Un paso prometido en el flujo que aparece declarado fuera de alcance (o al revés) |
| **§5 actores ↔ §6 camino feliz** | Un camino feliz cuyo protagonista no figura entre los actores, o un actor sin flujo alguno |
| **§7 Gatekeeper ↔ §2 hipótesis de valor** | Una métrica de éxito que no mide la hipótesis que dice validar |

Los cruces de la tabla son el **piso, no el techo**: si detectas cualquier otra contradicción entre
áreas, va igual.

**Qué hacer con lo que encuentres:** registrarlo en *Ambigüedades detectadas*, nombrando **las dos
áreas en conflicto** y **citando ambos extremos**. **No lo resuelvas** —ni eligiendo el que parezca
correcto, ni promediando, ni degradando el área a `parcial` para que "se pregunte igual"—: una
contradicción del cliente consigo mismo es un dato de primer orden y el humano es quien la deshace
(NC-1/NC-6). Si además deja el área incompleta, ajusta su estado de cobertura; pero el registro de la
ambigüedad es **obligatorio** en todo caso.

---

## Paso 4 — Confirmar por bloque y cerrar

1. **Copiar** `_templates/document_extract_temp.md` a `<EXTRACT>` y **rellenar** sus secciones sin
   alterar la estructura. Se **instancia** desde la plantilla, **nunca se escribe desde cero**
   (contrato del constructor de entregables, `methodology.md` §5.1): así el artefacto nace conforme y
   su forma es verificable por **diff** contra el esqueleto.
   > En esta escritura los campos de estado **nacen en su valor no confirmado**:
   > `Confirmado por el humano: no` y `Estado: borrador`. No los adelantes: todavía no has preguntado.
2. Presentar al humano un **resumen de cobertura en un solo turno**: qué áreas quedaron cubiertas, qué
   áreas preguntará el interviewer y qué ambigüedades se detectaron.
3. Pedir **una** confirmación de bloque. **No** confirmes área por área: eso reintroduce el cuestionario
   largo que §4.3 quiere evitar (parálisis por diseño).
4. Si el humano corrige algo (p. ej. *"§7 no está cubierta, ese número es de otro proyecto"*), ajustar la
   tabla de cobertura y volver a presentar solo lo corregido.
5. **Solo cuando el humano haya confirmado de verdad** —su respuesta ya está en la conversación—,
   hacer una **escritura aparte** que cambie `Confirmado por el humano` a `sí` y `Estado` a `cerrado`.
   Es una edición **separada** de la del punto 1, posterior a la respuesta humana: nunca en la misma
   pasada. El `document_extract.md` queda listo como insumo del `onboarding-interviewer` **y** —junto
   al log— del `onboarding-writer`.

> **El campo registra un hecho, no una intención.** `Confirmado por el humano: sí` afirma que una
> persona lo revisó. Escribirlo cuando aún vas a preguntar convierte el campo en ruido: quien lo lea
> aguas abajo —el interviewer, el writer, una auditoría— no puede distinguir un extracto validado de
> uno que nadie miró. Que la escritura sea **posterior y separada** es lo que hace que el campo
> signifique algo (§10: la evidencia es la traza y el artefacto, no tu narrativa).

---

## Paso 5 — Commit de etapa

Con el extracto ya **cerrado** (Paso 4.5), aplicar `_guideline/git-protocol.md` §2 (bootstrap) y §3
(commit de etapa):

- Etapa: **ingest** → mensaje `docs(prototipo): extracto del documento del cliente`.
- Artefacto confirmado: `<EXTRACT>`.

El commit va **después** de la confirmación humana, no antes: lo que se confirma es el artefacto
validado, no un borrador. Reportar hash y rama junto al resumen de cobertura. **No hacer `push`.**

---

## Reglas invariantes

- **Condicional:** sin `client_brief.*` no hay artefacto ni error; se cae al flujo por defecto.
- **La etapa cierra con commit:** el extracto confirmado se persiste en git (`_guideline/git-protocol.md`);
  una cadena de descubrimiento sin puntos de retorno no es reanudable (L-009).
- **Citar, no interpretar:** extractos textuales con localización; la síntesis es del writer.
- **Inferencia mínima:** *¿hay material para esta área?* y, solo para el caso de diseño, *¿esta área le
  corresponde al cliente?* — nada más.
- **Sesgo hacia el hueco:** ante la duda, `parcial`/`ausente`, nunca `cubierta` ni `n/a`.
- **`n/a` solo por diseño:** áreas que no provienen del cliente (canónicamente §3); nunca como atajo
  para no preguntar. Ante la duda entre `n/a` y `ausente`, gana `ausente`.
- **No fabricar campos de salida:** todo campo —incluidos los de Meta— se rellena con lo que el
  documento dice literalmente; si no lo dice, `<no declarado>`. Un valor plausible deducido es un
  hueco invisible.
- **Consistencia entre áreas:** tras el bucle de extracción, cruzar §6↔§9, §5↔§6 y §7↔§2 como piso; el
  extractor por casilleros no ve las contradicciones transversales.
- **No resolver ambigüedades:** se registran para que las pregunte el interviewer (NC-1).
- **La confirmación no se adelanta:** `Confirmado por el humano` nace en `no` y solo pasa a `sí` en una
  **escritura posterior y separada**, después de que el humano haya respondido.
- **Confirmación por bloque:** un solo turno de validación, no uno por área.
- **Instanciar, no escribir desde cero:** `<EXTRACT>` nace **copiando** `document_extract_temp.md` y
  rellenando sus secciones; no se reordena ni se elimina estructura (§5.1).
- **Single Writer:** escribes **solo** `document_extract.md`. No tocas `interview_document.md` ni
  `discovery.md` ni el propio `client_brief.*` (el documento del cliente es **de solo lectura**).
- **Idioma:** comunicarse en el idioma del proyecto (por defecto, español).
