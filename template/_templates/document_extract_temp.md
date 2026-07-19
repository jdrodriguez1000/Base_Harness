<!-- =========================================================================
document_extract_temp.md — PLANTILLA del EXTRACTO del documento del cliente
---------------------------------------------------------------------------
Artefacto de TRABAJO (intermedio), FUERA del ciclo de incremento (§3).
Lo PRODUCE el onboarding-reader a partir de  _context/client_brief.*  (el
documento con que el cliente describe lo que quiere construir), ANTES de la
entrevista. Es el PRIMER artefacto del estadio de Prototipo cuando el cliente
entrega documentación; si no hay  client_brief.* , este archivo no existe y la
entrevista se conduce completa (flujo por defecto).

PARA QUÉ SIRVE — dos lectores, dos usos:
  1. onboarding-interviewer → lee la tabla de COBERTURA para saber qué áreas
     ya tienen material y preguntar SOLO los huecos (no repreguntar lo que el
     cliente ya escribió).
  2. onboarding-writer → lo lee JUNTO CON  interview_document.md  al sintetizar
     discovery.md. Son sus DOS insumos: el material del documento vive aquí y
     NO se duplica en el log de la entrevista.

REGLA DE ORO: se CITA, no se interpreta. Cada área se rellena con extractos
TEXTUALES del brief (entre comillas, con su localización). Clasificar actores,
redactar el camino feliz o formalizar el Gatekeeper es trabajo del
onboarding-writer, NO de este artefacto. La única inferencia permitida aquí es
binaria: "¿esta área tiene material en el documento, sí o no?".

Se instancia en  _prototype/document_extract.md .

Esta plantilla modela la FORMA: sustituye los <marcadores> y borra estos
comentarios al instanciar.
========================================================================= -->

# Extracto del documento del cliente — <nombre-del-proyecto>

## Meta

- **Proyecto:** <nombre-del-proyecto>
- **Documento origen:** <ruta y nombre exacto, p. ej. _context/client_brief.pdf>
- **Formato / extensión:** <md | pdf | docx | txt | …>
- **Extraído por:** onboarding-reader
- **Fecha:** <YYYY-MM-DD>
- **Confirmado por el humano:** <sí | no> <!-- confirmación por bloque, antes de pasar al interviewer -->
- **Estado:** borrador <!-- borrador | cerrado (listo para el interviewer) -->

## Cobertura

<!-- TABLA DE CONTROL. Es lo primero que lee el onboarding-interviewer: le dice
     qué preguntar y qué NO repreguntar. Las áreas §1–§10 son las secciones de
     discovery_temp.md.
     Estado de cada área:
       - cubierta — el documento trae material suficiente; el interviewer NO pregunta.
       - parcial  — hay material pero incompleto; el interviewer pregunta SOLO lo que falta
                    (detállalo en "Qué falta").
       - ausente  — el documento no dice nada; el interviewer pregunta el área completa.
     Ante la duda, marca PARCIAL o AUSENTE: repreguntar de más cuesta una pregunta;
     dar por cubierto de menos mete un hueco silencioso en el discovery (NC-1). -->

| Área | Tema | Estado | Qué falta (si parcial) |
|---|---|---|---|
| §1 | Objetivo y contexto | <cubierta \| parcial \| ausente> | <qué queda por elicitar, o —> |
| §2 | Hipótesis de valor central | <…> | <…> |
| §3 | Tipo de prototipo dominante | <…> | <…> |
| §4 | Stakeholders | <…> | <…> |
| §5 | Actores | <…> | <…> |
| §6 | Camino feliz + medio por actor | <…> | <…> |
| §7 | Gatekeeper | <…> | <…> |
| §8 | Timebox | <…> | <…> |
| §9 | Exclusiones | <…> | <…> |
| §10 | Split por audiencia (opcional) | <…> | <…> |

## Extractos por área

<!-- Una subsección por área con estado "cubierta" o "parcial". Las áreas
     "ausente" se OMITEN aquí (ya constan en la tabla de arriba).
     Cada extracto es una CITA TEXTUAL del documento con su localización, para
     que el writer pueda trazar cada dato de discovery.md hasta el brief. -->

### §1 — Objetivo y contexto

> "<cita textual del documento>"
> — <localización: p. ej. p. 2, §"Resumen ejecutivo">

### §2 — Hipótesis de valor central

> "<cita textual>"
> — <localización>

<!-- ...continuar con las áreas que tengan material (§3 … §10).
     Si un área tiene varias citas relevantes, añádelas todas como bloques
     sucesivos: es preferible sobre-citar a resumir (resumir = interpretar). -->

## Ambigüedades detectadas

<!-- Puntos donde el documento dice algo CONTRADICTORIO, VAGO o AMBIGUO. NO los
     resuelvas: pásalos al interviewer para que los pregunte al humano. Esto es
     NC-1/NC-6 — no tomar decisiones silenciosas sobre lo que el cliente quiso decir. -->

| # | Área | Qué dice el documento | Por qué es ambiguo |
|---|---|---|---|
| A1 | <§n> | <cita o paráfrasis mínima> | <contradicción / vaguedad / doble lectura> |

## Fuera de alcance del descubrimiento

<!-- Material del documento que NO mapea a ninguna área §1–§10 (p. ej. cláusulas
     contractuales, presupuesto, calendario comercial, anexos legales). Se lista
     para dejar constancia de que se leyó y se descartó CONSCIENTEMENTE, no por
     omisión. Si no hay nada, escribe "ninguno". -->

- <tema del documento que no alimenta el descubrimiento>
