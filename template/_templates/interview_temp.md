<!-- =========================================================================
interview_temp.md — PLANTILLA del LOG CRUDO de la entrevista de descubrimiento
---------------------------------------------------------------------------
Artefacto de TRABAJO (intermedio), FUERA del ciclo de incremento (§3).
Lo PRODUCE el onboarding-interviewer: una pregunta → su respuesta → se GUARDA
de inmediato (append-only). Es el estado REANUDABLE de la entrevista: si se
suspende, se retoma por la primera pregunta sin responder. NO se interpreta ni
se estructura aquí — de eso se encarga el onboarding-writer, que sintetiza este
log en  discovery.md  (ver discovery_temp.md).

Al abrir el descubrimiento se copia a  _prototype/interview_document.md  y se va
rellenando ENTRADA a ENTRADA.

REGLA DE ORO: append-only. Nunca se borra ni se reescribe una entrada ya
guardada; a lo sumo se AÑADE una entrada de aclaración. Cada respuesta se
persiste ANTES de pasar a la siguiente pregunta.

Esta plantilla modela la FORMA: sustituye los <marcadores> y borra estos
comentarios al instanciar.
========================================================================= -->

# Entrevista de descubrimiento (log crudo) — <nombre-del-proyecto>

## Meta

- **Proyecto:** <nombre-del-proyecto>
- **Entrevistado:** <humano/cliente que responde>
- **Entrevistador:** onboarding-interviewer
- **Inicio:** <YYYY-MM-DD>
- **Timebox acordado:** <p. ej. "30 min" | "12 preguntas" | sin acordar>
  <!-- Se ACUERDA con el humano al abrir la entrevista (§4.3: duración tope ACORDADA), antes del
       bucle, y cubre además el área §8 — no se vuelve a preguntar. Al reanudar se LEE de aquí, no se
       renegocia. Si quedó "sin acordar", el cierre se propone solo por suficiencia (camino feliz del
       generador cubierto), nunca por tiempo. -->
- **Estado:** en curso <!-- en curso | cerrada (suficiente para arrancar) -->
- **Sección en curso:** <§n de discovery_temp.md> <!-- pista de reanudación: por dónde iba -->
- **Extracto documental:** <ruta de document_extract.md | ninguno>
  <!-- Si el cliente entregó un  _context/client_brief.* , el onboarding-reader produjo antes un
       document_extract.md. En ese caso esta entrevista cubre SOLO los huecos (áreas parciales/
       ausentes + ambigüedades); las áreas ya cubiertas por el documento NO se repreguntan y NO
       aparecen en este log — viven en el extracto, y el onboarding-writer lee AMBOS archivos. -->
- **Áreas cubiertas por el documento (no se preguntan):** <§n, §n… | ninguna>

<!-- El "área" mapea a la sección de discovery_temp.md que la pregunta busca cubrir
     (§1 objetivo · §2 hipótesis · §3 tipo de prototipo · §4 stakeholders ·
      §5 actores · §6 camino feliz + medio por actor · §7 Gatekeeper · §8 timebox ·
      §9 exclusiones · §10 split). Sirve para que el writer sepa dónde colocar cada respuesta. -->

## Registro de la entrevista

### Q1 · área: <§n — tema>
**P:** <pregunta tal como se hizo>
**R:** <respuesta del humano, textual o parafraseada fielmente — sin interpretar>

### Q2 · área: <§n — tema>
**P:** <pregunta>
**R:** <respuesta>

<!-- ...seguir añadiendo Q3, Q4, ... una por una, guardando tras cada respuesta.
     Si una respuesta abre un hueco importante, la SIGUIENTE pregunta lo indaga;
     no se rellena por cuenta propia. -->

## Cierre

<!-- Rellenar solo al cerrar la entrevista (Estado: cerrada). -->

- **Motivo de cierre:** <suficiente para el camino feliz del generador | timebox agotado>
- **Huecos declarados:** <temas no cubiertos que el writer marcará como pendientes/exclusiones, o "ninguno">
  <!-- OJO con el extracto: un hueco es un área que NI el documento NI la entrevista cubren. Un área
       cubierta por  document_extract.md  NO es un hueco aunque no aparezca en este log; declararla
       como tal haría que el writer la excluyera del discovery.md teniendo el material a mano. -->
