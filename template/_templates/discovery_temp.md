<!-- =========================================================================
discovery_temp.md — PLANTILLA del ENTREGABLE DE DESCUBRIMIENTO (§4.3 y §5)
---------------------------------------------------------------------------
Insumo del estadio de Prototipo (§4), FUERA del ciclo de incremento (§3).
Lo PRODUCE el Descubridor entrevistando al humano/cliente (§5); es el ÚNICO
insumo del Prototipador. Orden del estadio: Descubridor → Prototipador.

Al abrir el estadio de Prototipo se copia a  _prototype/discovery.md  y se
rellena reemplazando cada <marcador>.

ALCANCE ACOTADO (crítico, §4.3/§5): entendimiento RÁPIDO y SUFICIENTE para
arrancar —lo justo para prototipar el camino feliz del GENERADOR—, no un
relevamiento exhaustivo. Evita el cuestionario infinito → parálisis por diseño.

Esta plantilla modela la FORMA, no un caso real: los <marcadores> se sustituyen
al instanciar. Borra los ejemplos y los comentarios <!-- --> al rellenar.
========================================================================= -->

# Entregable de descubrimiento — <nombre-del-proyecto>

## Meta

- **Proyecto:** <nombre-del-proyecto | no declarado> <!-- FUENTE: _context/project.yaml (project.name).
     Regla de procedencia (§0.2 de methodology.md): metadato, NO se sintetiza del log ni del extracto. -->
- **Cliente / solicitante:** <quién pide el sistema> <!-- FUENTE: el brief o la entrevista (contenido
     del cliente), NO project.yaml. Si ninguna de las dos lo trae: "no declarado". -->
- **Descubridor:** <agente que condujo la entrevista>
- **Fecha:** <YYYY-MM-DD>
- **Timebox del descubrimiento:** <p. ej. 1 sesión / 2 h> <!-- disciplina de alcance: acotar la propia elicitación -->
- **Procedencia de los insumos:** <log: cerrada | en curso · extracto: confirmado | sin confirmar | ninguno>
     <!-- Contrato de entrada (§5.1 paso 0 de methodology.md). Estado REAL de lo que se sintetizó, no el
     deseado. El Prototipador construye sobre este entregable: si se apoya en insumos no validados,
     tiene que poder verlo aquí sin releer la cadena entera. -->
- **Estado:** borrador <!-- borrador | cerrado (listo para el Prototipador) -->

## 1. Objetivo y contexto

<!-- Qué quiere el cliente y por qué. Problema a resolver y valor esperado, en 3–6 líneas.
     Sin solución técnica todavía: el "qué/para qué", no el "cómo". -->

<qué quiere el cliente, el problema y el valor esperado>

## 2. Hipótesis de valor central

<!-- LO QUE EL PROTOTIPO DEBE VALIDAR (§4.3). Es la afirmación falsable que el
     camino feliz del generador pone a prueba.
     Agnóstico: en software/producto suele ser un flujo de UI; en DS/ML es que
     "la señal existe en los datos y un baseline la captura". -->

> <afirmación falsable que el prototipo valida>

## 3. Tipo de prototipo dominante

<!-- §4.2: qué riesgo manda decide qué prototipo hacer PRIMERO.
     - DESEABILIDAD (riesgo de mercado): ¿lo quieren? → mockups/wireframes/mago de Oz.
     - FACTIBILIDAD  (riesgo técnico):   ¿es posible? → spike/notebook/PoC. En DS/ML suele mandar. -->

- **Tipo dominante:** <deseabilidad | factibilidad>
- **Por qué:** <riesgo dominante que lo justifica>
- **Secuencia prevista:** <p. ej. solo factibilidad | deseabilidad → factibilidad>

## 4. Stakeholders

<!-- Quiénes tienen INTERÉS en el sistema (patrocinan, se ven afectados, deciden),
     NO necesariamente lo usan. Los que lo USAN van en §5 (actores). -->

| Stakeholder | Interés / expectativa | Poder de decisión |
|---|---|---|
| <rol o persona> | <qué espera del sistema> | <alto \| medio \| bajo> |

## 5. Actores (taxonomía por defecto — §4.3)

<!-- LENTE de elicitación: un PISO, no un techo. Se pregunta SIEMPRE por los tres
     arquetipos (definidos por su relación con el VALOR, no por su cargo), pero
     pueden FALTAR o COLAPSAR — decláralo explícitamente en "Estado".
       - Generador     — origina el valor central por uso directo; razón de ser.
       - Operador      — aprovecha lo que el generador produce y lo convierte en valor posterior.
       - Administrador — sostiene y gobierna el sistema (altas/bajas, config, métricas). -->

| Arquetipo | Actor concreto | Estado | Notas |
|---|---|---|---|
| **Generador** | <quién> | presente | <obligatorio: sin generador no hay sistema> |
| **Operador** | <quién o —> | <presente \| ausente \| colapsa en generador> | <por qué> |
| **Administrador** | <quién o —> | <presente \| ausente \| colapsa en …> | <por qué> |

<!-- Colapsos/ausencias frecuentes: sin operador; sin administrador; los tres
     concentrados en el generador. Lo importante es DECLARARLO, no forzar tres actores. -->

## 6. Camino feliz por actor

<!-- Solo el/los flujo(s) crítico(s) que validan la hipótesis de valor (§4.3).
     PRIORIDAD NO LINEAL:
       - El del GENERADOR es OBLIGATORIO para arrancar → lo construye el Prototipador primero.
       - Operador y administrador: BAJO DEMANDA (cuando la app lo requiera, días/semanas
         después); mientras tanto se difieren o se simulan (mago de Oz, §4.3). NO en secuencia
         inmediata tras el generador.
     MEDIO/CANAL POR ACTOR (§4.2): el medio es propiedad de CADA actor, no del proyecto — un actor
     vive en app, otro en web, etc.; "ambos" = dos actores en dos medios, construidos en momentos
     distintos, no un actor en dos medios. Es una decisión de PRODUCTO del cliente (la elicita el
     interviewer). El Prototipador la lee y obedece. OJO: el medio del PROTOTIPO desechable no tiene
     por qué ser el del producto final — se materializa en la tecnología más barata que valide la
     hipótesis (p. ej. un HTML clicable que simula un móvil). -->

### Generador — <actor> · **[obligatorio · lo construye el Prototipador primero]** · medio: <app | web | notebook | CLI | …>

1. <paso 1 del camino feliz>
2. <paso 2>
3. <resultado / valor generado>

### Operador — <actor o —> · [bajo demanda] · medio: <app | web | … | —>

<!-- Si el operador está ausente/colapsado, escribe "N/A — ver §5" y no inventes flujo. -->

1. <paso 1>
2. <…>

### Administrador — <actor o —> · [bajo demanda] · medio: <app | web | … | —>

1. <paso 1>
2. <…>

## 7. Gatekeeper (criterio de salida cuantitativo — §4.3/§4.4)

<!-- Métrica de éxito MEDIBLE, fijada de antemano, que decide si se pasa al MVP.
     Es un gate de madurez DURO: se cruza con evidencia + decisión humana (P5), no por un agente.
     Ej. deseabilidad: "N usuarios objetivo, ≥X% comprende el valor".
     Ej. factibilidad: "el baseline alcanza ≥Y en <métrica>". -->

- **Métrica:** <qué se mide>
- **Umbral de éxito:** <valor concreto y medible>
- **Cómo se mide:** <método / fuente de evidencia>

## 8. Timebox y feature freeze (§4.3)

- **Duración tope del prototipo:** <p. ej. 1 semana>
- **Al cerrar el timebox:** feature freeze → se congela y se pasa al MVP; las mejoras
  estéticas/secundarias se posponen.

## 9. Exclusiones explícitas (§4.3)

<!-- Qué queda FUERA del prototipo, por escrito, para evitar el scope creep y la
     parálisis por diseño. Sé concreto. -->

- <lo que NO se prototipa — 1>
- <lo que NO se prototipa — 2>

## 10. Split por audiencia — *opcional* (§4.3)

<!-- Solo si aplica: en vez de un artefacto monolítico, validaciones especializadas
     por audiencia (p. ej. usabilidad con usuarios vs. demo para clientes/aliados).
     Si no aplica, borra esta sección. -->

| Audiencia | Artefacto | Objetivo de la validación |
|---|---|---|
| <a quién> | <qué se le muestra> | <qué valida> |
