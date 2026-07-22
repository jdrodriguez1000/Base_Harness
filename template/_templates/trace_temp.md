<!-- =========================================================================
trace_temp.md — PLANTILLA de la TRAZA DE EJECUCIÓN del proyecto
---------------------------------------------------------------------------
Artefacto de OBSERVABILIDAD. No es un entregable ni alimenta a ningún agente
aguas abajo: existe para responder "¿QUÉ HIZO el agente, y en qué orden?"
DENTRO de la carpeta del proyecto ejecutado, sin depender del transcript de la
herramienta que lo corrió (que es propietario, no versionable y se pierde).

Se instancia UNA SOLA VEZ por proyecto en  _trace/trace.md  y crece durante toda
la vida del proyecto. NO se instancia una por agente ni una por etapa: el
archivo es ÚNICO y COMPARTIDO, y cada fila declara qué agente la escribió.
Motivo: el ORDEN GLOBAL entre etapas es en sí mismo la evidencia — checks como
"¿el writer leyó el extract ANTES de escribir el discovery?" solo son
verificables si todo vive en una misma secuencia.

APPEND-ONLY. Igual que  interview_document.md : se anexa UNA FILA POR EVENTO, EN
EL MOMENTO en que ocurre. Nunca se reescribe, nunca se reordena, nunca se
resume. Redactar la traza al terminar la etapa la invalida: sería el agente
reconstruyendo de memoria (el fallo de L-030, donde una pregunta se registró
con la redacción hecha a posteriori). Si el agente muere a mitad de la
ejecución, lo ya anexado sigue siendo evidencia válida.

QUÉ ES Y QUÉ NO ES
  - ES observabilidad: el registro de lo que pasó.
  - NO ES evaluación: no dice si estuvo BIEN. Eso lo deciden  conformance.sh ,
    los oráculos de trazabilidad y el gate humano. No mezclar (§8 vs §10).

NATURALEZA DE LA EVIDENCIA — leer antes de confiar en este archivo:
Esta traza es AUTODECLARADA: la escribe el propio agente sobre sí mismo. L-020
ya estableció que el reporte de un subagente NO es verificación. Su valor no
está en ser confiable, sino en ser CONTRASTABLE: cada fila se puede cotejar
contra  git log  y contra los artefactos reales, y una traza que se contradiga
con ellos es, ella misma, la señal de un fallo. Evidencia débil pero
verificable. La evidencia dura (no autodeclarada, producida por hooks) es una
capa POSTERIOR que reutilizará este mismo formato.

REGLA DE ORO — qué puede entrar aquí:
Si el agente NO PUEDE OBSERVARLO, NO VA EN ESTA TRAZA. Un agente no conoce sus
tokens consumidos ni la hora del reloj: pedírselo produce un número inventado
con apariencia de dato medido, que es peor que no tenerlo (modo de fallo de
L-005 y L-030). Por eso el timestamp se obtiene con  date  vía  Bash , nunca lo
escribe el modelo, y por eso NO hay columna de tokens (ver "Ampliaciones
previstas" al final).

EXCEPCIÓN A SINGLE WRITER (importante):
Los perfiles de conformidad de los agentes exigen que cada uno escriba SOLO su
propio artefacto (R6 del reader, W4 del writer, P7 del prototipador).
_trace/trace.md  queda EXPRESAMENTE FUERA de esa regla: es un log compartido de
solo-anexado al que escriben todos los agentes de etapa. Sin esta excepción
declarada, la primera corrida reprobaría a los tres por tocar un archivo ajeno.

Esta plantilla modela la FORMA: sustituye los <marcadores> y borra estos
comentarios al instanciar.
========================================================================= -->

# Traza de ejecución — <nombre-del-proyecto>

## Meta

- **Proyecto:** <nombre-del-proyecto | no declarado> <!-- FUENTE: _context/project.yaml (project.name).
     No se deduce de ningún otro artefacto. Si no existe o no lo trae: "no declarado". -->
- **Iniciada:** <YYYY-MM-DD>
- **Naturaleza:** autodeclarada (contrastable contra `git log` y artefactos)
- **Formato:** append-only, una fila por evento

## Registro

<!-- UNA FILA POR EVENTO, anexada EN EL MOMENTO en que ocurre.

     COLUMNAS
       #        Secuencia global, correlativa (001, 002, …). Nunca se reinicia por
                agente ni por etapa: es lo que hace legible el orden ENTRE etapas.
       agente   Nombre del agente que ejecuta (onboarding-reader, onboarding-writer,
                prototype-builder, …). Obligatorio en TODAS las filas: es lo que
                permite que el archivo sea único.
       modelo   Modelo con el que corre, tal cual el campo `model:` de su propio
                frontmatter (sonnet | opus | haiku | equivalente de otra herramienta).
                Sin este dato NO se puede atribuir el resultado de una corrida a un
                modelo, y la comparación entre corridas — que es el motivo de existir
                de la observabilidad — deja de ser posible.
       evento   Uno de los ocho tipos de abajo. No inventar tipos nuevos.
       objetivo Sobre QUÉ actúa: ruta de archivo, hash de commit, o "humano".
                Si no aplica, un guion.
       detalle  Una línea, concreta. No prosa, no justificación, no relato.
       ts       Hora del evento (HH:MM:SS), obtenida con `date` vía `Bash`.
                NUNCA escrita de memoria por el modelo.

     TIPOS DE EVENTO
       start    Comienza una invocación del agente. Delimita la corrida: un mismo
                agente puede invocarse varias veces a lo largo del proyecto (p. ej.
                prototype-builder construye el generador hoy y el operador semanas
                después). En `detalle`, el número de invocación.
       read     Leyó un archivo. El ORDEN de estas filas es lo que hace verificables
                los checks de "leer antes de escribir" (R2 del reader, W0/W1 del
                writer, P1 del prototipador).
       write    Escribió o editó un archivo. En `detalle`, el estado en que lo deja
                (borrador / cerrado / confirmado), no un resumen del contenido.
       ask      Preguntó algo al humano y cedió el turno. `objetivo` = humano.
       confirm  El humano respondió confirmando o aprobando. Va DESPUÉS del `ask`
                correspondiente; que exista `confirm` sin `ask` previo es, en sí
                mismo, un hallazgo.
       commit   Ejecutó un commit. `objetivo` = hash corto; `detalle` = mensaje.
                Es la fila más contrastable de todas: o está en `git log`, o no.
       close    Cerró la etapa (feature freeze, entregable cerrado, gate cedido).
                En `detalle`, POR QUÉ terminó.
       end      Termina la invocación. Cierra el bloque abierto por `start`. Junto
                con `start` permite medir la duración real, y con ella contrastar
                un cierre que alegue "timebox agotado" (P10 del prototipador)
                contra el tope declarado en §8 del discovery. -->

| # | agente | modelo | evento | objetivo | detalle | ts |
|---|---|---|---|---|---|---|
| 001 | <nombre-del-agente> | <modelo> | start | — | invocación #1 | <HH:MM:SS> |
| 002 | <nombre-del-agente> | <modelo> | read | <ruta/del/archivo> | <qué leyó, en una línea> | <HH:MM:SS> |
| 003 | <nombre-del-agente> | <modelo> | write | <ruta/del/archivo> | <estado en que lo deja> | <HH:MM:SS> |
| 004 | <nombre-del-agente> | <modelo> | commit | <hash-corto> | <mensaje del commit> | <HH:MM:SS> |
| 005 | <nombre-del-agente> | <modelo> | ask | humano | <qué se preguntó> | <HH:MM:SS> |
| 006 | <nombre-del-agente> | <modelo> | confirm | humano | <qué confirmó> | <HH:MM:SS> |
| 007 | <nombre-del-agente> | <modelo> | close | — | <por qué terminó la etapa> | <HH:MM:SS> |
| 008 | <nombre-del-agente> | <modelo> | end | — | <resultado de la invocación> | <HH:MM:SS> |

<!-- Las filas de arriba son EJEMPLO DE FORMA, no un guion obligatorio: ni el orden
     ni el conjunto de eventos es fijo. Un onboarding-reader que no encuentra
     client_brief.* deja legítimamente start → end, sin ninguna escritura — y esa
     ausencia de filas ES la evidencia que verifica su check R1 (ruta condicional). -->

## Ampliaciones previstas

<!-- Se documentan aquí para que el formato NO haya que rehacerlo cuando lleguen.
     No añadir estas columnas mientras la traza siga siendo autodeclarada: hoy
     violarían la regla de oro (el agente no puede observarlas). -->

- **`tokens`** — consumo por invocación. Primera columna a añadir. Requiere la capa
  de evidencia dura (hooks / datos de uso): un agente no puede observar su propio
  consumo, así que hoy solo podría inventarlo. Habilita justificar con cifras la
  elección de modelo por agente.
- **Traza cruda producida por hooks** — convivirá en esta misma carpeta `_trace/`,
  junto a este archivo, sin rediseñarlo: la traza autodeclarada y la dura se
  contrastan entre sí.
