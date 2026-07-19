<!-- =========================================================================
client_brief_temp.md — PLANTILLA del DOCUMENTO DEL CLIENTE
---------------------------------------------------------------------------
La escribe el HUMANO, no un agente. Se copia a  _context/client_brief.md  y se
rellena con lo que se sepa. Su presencia dispara la RUTA DOCUMENTAL del estadio
de Prototipo: el onboarding-reader la lee y extrae citas a
_prototype/document_extract.md, y el onboarding-interviewer entrevista SOLO los
huecos que queden.

PARCIAL POR DISEÑO (crítico): NO es un formulario que haya que completar. Cada
sección que llenes es una que NADIE te repreguntará; cada una que dejes vacía se
cubre en la entrevista, que es conversada y más fácil. Dejar algo en blanco es
una respuesta válida y esperada — inventar para rellenar es peor que el vacío,
porque el agente no puede distinguir un dato firme de uno improvisado.

Escribe en prosa, como le explicarías el proyecto a alguien nuevo. No hace falta
lenguaje técnico ni respetar el formato al pie de la letra: los títulos son una
guía de temas, no un molde rígido.

MAPEO al discovery (lo usa el onboarding-reader; el humano puede ignorarlo):
  1→§1 objetivo · 2→§2 hipótesis · 3→§4 stakeholders · 4→§5 actores ·
  5→§6 camino feliz + medio · 6→§7 gatekeeper · 7→§8 timebox · 8→§9 exclusiones ·
  §3 (tipo de prototipo) y §10 (split) los DEDUCE el Descubridor, no se piden aquí.
========================================================================= -->

# Qué quiero construir — <nombre-del-proyecto>

- **Quién escribe esto:** <tu nombre y rol>
- **Fecha:** <YYYY-MM-DD>

> Rellena lo que sepas y **deja en blanco lo que no**. Lo que falte se conversa
> después. No borres los títulos que dejes vacíos: saber que un tema quedó abierto
> también es información útil.

---

## 1. Qué problema quiero resolver

<!-- El "qué" y el "para qué", no el "cómo". Si ya tienes una solución técnica en
     mente, guárdala para la sección 9. -->

<Qué pasa hoy que no te gusta, a quién le duele y qué valor esperas obtener.
Tres a seis líneas bastan.>

## 2. Cómo sabría que esto funcionó

<!-- Lo más valioso del documento y lo que más se suele omitir. -->

<Si el proyecto sale bien, ¿qué cambia? ¿Qué verías pasar que hoy no pasa?
Descríbelo aunque no sepas medirlo todavía.>

## 3. Quién tiene interés en esto

<!-- Los que DECIDEN, PAGAN o se ven AFECTADOS — no necesariamente quienes lo usan.
     Los que lo usan van en la 4. -->

| Persona o rol | Qué espera | ¿Decide? |
|---|---|---|
| <quién> | <qué espera del sistema> | <sí / no> |

## 4. Quién va a usarlo

<!-- Piensa en TIPOS de usuario, no en personas concretas. Es normal que haya uno
     solo, o que una misma persona haga varias cosas: dilo y ya. -->

Para cada tipo de usuario, quién es y qué hace con el sistema:

- **<tipo de usuario 1>** — <quién es y qué hace>
- **<tipo de usuario 2>** — <quién es y qué hace>

Tres preguntas que ayudan a no dejarse a nadie fuera:

- ¿Quién **produce** el valor principal usando el sistema? *(el usuario imprescindible)*
- ¿Quién **recibe o aprovecha** lo que ese primero produjo?
- ¿Quién **mantiene** el sistema por dentro: da de alta usuarios, configura, mira métricas?

Si alguno no existe en tu caso, escríbelo: *"no hay"* es una respuesta correcta.

## 5. Cómo lo usarían, paso a paso

<!-- El camino normal, cuando todo sale bien. Sin errores, sin excepciones, sin
     casos raros: eso viene mucho después. -->

**<tipo de usuario más importante>** — ¿dónde lo usa? <app móvil | web | escritorio | otro>

1. <primer paso>
2. <segundo paso>
3. <qué obtiene al final>

<!-- Repite el bloque para otros tipos de usuario si los tienes claros. Si no, déjalo:
     se prototipa primero el usuario principal de todos modos. -->

## 6. Cómo mediríamos el éxito

<!-- Si no tienes un número, describe el criterio en palabras y el Descubridor
     ayudará a convertirlo en métrica. -->

<Qué habría que observar o medir para decidir que vale la pena seguir invirtiendo.>

## 7. Plazos y restricciones

- **¿Para cuándo lo necesitas?** <fecha o "sin fecha fija">
- **Presupuesto o límite de esfuerzo:** <si aplica>
- **Restricciones innegociables:** <normativa, tecnología obligatoria, sistemas con los
  que debe convivir, políticas de datos…>

## 8. Qué NO quiero que se haga ahora

<!-- Tan importante como lo que sí. Acota el alcance y evita que el prototipo
     crezca sin control. -->

- <lo que queda fuera — 1>
- <lo que queda fuera — 2>

## 9. Referencias, ideas previas y material existente

<!-- Todo lo que ya exista ahorra trabajo: enlaces, capturas, documentos, un
     sistema parecido, hojas de cálculo que hoy hacen el trabajo a mano. -->

- <referencia, enlace o archivo — y por qué es relevante>

## 10. Dudas que tengo yo

<!-- Lo que tú mismo no tienes resuelto. Declararlo evita que el agente asuma que
     está decidido y construya sobre una base falsa. -->

- <lo que aún no tienes claro>
