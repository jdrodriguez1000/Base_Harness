<!-- =========================================================================
interview_temp.md — PLANTILLA del LOG CRUDO de la entrevista de descubrimiento
---------------------------------------------------------------------------
Artefacto de TRABAJO (intermedio), FUERA del ciclo de incremento (§3).
Lo PRODUCE el onboarding-interviewer: una pregunta → su respuesta → se GUARDA
de inmediato (append-only). Es el estado REANUDABLE de la entrevista: si se
suspende, se retoma por la primera pregunta sin responder. NO se interpreta ni
se estructura aquí — de eso se encarga el onboarding-writer, que sintetiza este
log en  discovery.md  (ver discovery_temp.md).

Al abrir el descubrimiento se copia a la carpeta del estadio de prototipo
(p. ej.  <estadio-prototipo>/interview_document.md ; la numeración de carpeta es
convención del proyecto, no obligación) y se va rellenando ENTRADA a ENTRADA.

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
- **Estado:** en curso <!-- en curso | cerrada (suficiente para arrancar) -->
- **Sección en curso:** <§n de discovery_temp.md> <!-- pista de reanudación: por dónde iba -->

<!-- El "área" mapea a la sección de discovery_temp.md que la pregunta busca cubrir
     (§1 objetivo · §2 hipótesis · §3 tipo de prototipo · §4 stakeholders ·
      §5 actores · §6 camino feliz · §7 Gatekeeper · §8 timebox · §9 exclusiones ·
      §10 split). Sirve para que el writer sepa dónde colocar cada respuesta. -->

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
