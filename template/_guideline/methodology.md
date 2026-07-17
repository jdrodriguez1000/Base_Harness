# Metodología de Construcción

Esta es la **metodología de ingeniería** del harness: **cómo** un proyecto construye sus entregables
de forma disciplinada, trazable y reanudable, avanzando siempre **de menos a más** —desde un
**prototipo de alto nivel** hasta un **MVP** y luego hasta un **producto evolucionado/final**.

> **Agnóstica.** No asume dominio, lenguaje, stack ni framework. Cubre dos familias de proyecto:
> **(1) Desarrollo de software** y **(2) Ciencia de datos / Machine Learning**, con una **espina
> común** y adaptaciones por tipo.

> **Relación con el comportamiento.** Este documento desarrolla el *cómo* del trabajo; el *qué* del
> comportamiento de los agentes lo fija `_guideline/principles.md` (P1–P8, E1–E13, NC-1…NC-6), que es
> **vinculante y prevalente**. Ante conflicto, manda `principles.md`.

---

## 0. Propósito y Mapa de fuentes

### 0.1 Propósito
Reducir el espacio de decisiones probabilísticas durante la **construcción**, encuadrando el trabajo
de los agentes mediante **prototipado, especificación, planificación, validación y verificación
independiente**, con el **humano como GateKeeper**. Primero se **explora** (prototipo de alto nivel) y
luego se **consolida** el entregable, incremento a incremento.

### 0.2 Mapa de fuentes de verdad
Este documento no repite lo que ya tiene dueño canónico:

| Tema | Fuente canónica |
|---|---|
| Comportamiento de agentes: Principios (P), Estándares (E), Normas (NC) | **`_guideline/principles.md`** |
| Marco operativo: memoria, protocolos de sesión, portabilidad | **`AGENTS.md`** (+ `CLAUDE.md`/`GEMINI.md` como punteros) |
| Contexto declarativo del proyecto (metadatos, repo, memoria activa) | **`_context/project.yaml`** |
| Estado y avance entre sesiones | **`_persistence/`** |
| Plantillas de artefactos por incremento | **`_template/`** (convención) |
| **Metodología de construcción** (este archivo): flujo, madurez, gates, roles, evaluación | **este documento** |

> **Comportamiento vinculante.** Todo agente que participe en la construcción cumple los P/E/NC de
> `principles.md` como restricciones inmutables.

---

## 1. Los dos ejes del trabajo

El avance "de menos a más" ocurre en **dos ejes simultáneos**:

- **Eje de MADUREZ (macro).** El producto atraviesa estadios: **Prototipo de alto nivel → MVP →
  Producto Evolucionado/Final**. Cada estadio tiene un **objetivo**, un **alcance acotado** y un
  **criterio de salida** (gate de madurez). No se salta de estadio sin cruzarlo. El **Prototipo**
  valida —barato y desechable— *qué vale la pena construir* (deseabilidad y/o factibilidad, §4.2); el
  **MVP** es el primer producto **funcional**.
- **Eje de INCREMENTO (micro).** Dentro de cada estadio, el trabajo se construye por **slices
  verticales** —una funcionalidad o experimento completo de punta a punta— y no por capas
  horizontales. Cada slice se valida antes de ampliar (NC-4, *Tracer Bullet*).

```
MADUREZ →   Prototipo ───▶ MVP ───▶ Evolucionado/Final
              │              │              │
INCREMENTO ▼  slice·slice    slice·slice…   slice·slice…      (cada slice = un ciclo de vida, §3)
```

> El eje de madurez responde *¿cuánto producto?*; el eje de incremento responde *¿cómo se construye
> cada trozo?*. La disciplina de gates aplica a ambos: gate de **incremento** (§3) y gate de
> **madurez** (§4).

---

## 2. Tipos de proyecto y su adaptación

Los dos tipos comparten la **misma espina** de fases; cambian los artefactos y la naturaleza de la
validación.

**Espina común (un incremento):**
`Definir → Prototipar → Especificar → Planear → Construir → Verificar → Integrar`

| Fase | Software | Ciencia de datos / ML |
|---|---|---|
| Definir | Intención + historias de la funcionalidad | Pregunta/objetivo, métrica de éxito, disponibilidad de datos |
| Prototipar | Spike/boceto ejecutable (datos sintéticos) | Exploración de datos + experimento en notebook (EDA, baseline) |
| Especificar | Criterios de aceptación verificables | Criterios + **umbrales de métrica** y protocolo de evaluación |
| Planear | Tareas + casos de test | Tareas + pipeline de datos/entrenamiento + casos de evaluación |
| Construir | Bucle TDD (RED → GREEN → REFACTOR) | Pipeline determinista con tests **+ entrenamiento/evaluación** de la parte probabilística |
| Verificar | Auditoría independiente contra la spec | Auditoría independiente: métricas alcanzan umbrales + consistencia |
| Integrar | PR → gate humano → merge | PR → gate humano → merge (modelo/artefacto versionado) |

**Diferencia clave (NC-5, "orientado a comportamiento").**
- En **software determinista**, "Terminado" = **test en verde**.
- En **ML/probabilístico**, "Terminado" combina **tests** (para el código determinista: pipeline,
  features, I/O) **con un arnés de evaluación** que mide **umbrales de métrica** sobre un conjunto de
  validación, corrido **N veces** para medir consistencia (no una sola pasada). La parte que no es
  verificable mecánicamente se somete a evaluación calibrada (E3, §8).

> **Notebook antes de spec, en ambos.** El prototipo (notebook/spike) **informa** la spec; **no la
> reemplaza**. Al consolidar el entregable no se copia-pega el notebook: la spec y el ciclo de
> construcción reescriben la lógica con rigor. El notebook queda como artefacto de referencia/demo.

> **Dos usos de "prototipo".** Aquí, **Prototipar** es una *fase dentro de cada incremento* (el spike
> que informa la spec). No confundir con el **estadio de madurez** *Prototipo de alto nivel* y sus dos
> tipos —deseabilidad y factibilidad—, que se tratan en §4.

---

## 3. Ciclo de vida de un incremento

Ninguna pieza se produce sin una definición previa, un prototipo aprobado y un mecanismo de
validación. El ciclo de un incremento, con sus **gates humanos** (🚦):

| # | Fase | Responsable (arquetipo, §5) | Artefacto / Acción |
|---|---|---|---|
| 1 | Definir el incremento | Humano + sesión principal | Acuerdo de intención + rama de trabajo |
| 2 | Escribir el contrato | Sesión principal | Contrato del incremento ("estrella polar" / definición de Terminado) |
| 3 | Definir | *Definidor* | Definición (necesidades / historias) |
| 4 | Prototipar | *Prototipador* | Notebook/spike con **datos sintéticos** |
| 5 | **🚦 Gate humano** | Humano | Revisa y aprueba el prototipo |
| 6 | Especificar | *Especificador* | Spec con criterios verificables (y umbrales, en ML) |
| 7 | **🚦 Gate humano** | Humano | Aprueba / rechaza la spec |
| 8 | Planear | *Planificador* | Plan de tareas + casos de test/evaluación |
| 9 | **🚦 Gate humano** | Humano | Aprueba / rechaza el plan |
| 10 | Construir | *Probador* → *Implementador* → *Refactorizador* | RED → GREEN → REFACTOR (+ evaluación en ML) |
| 11 | Probar integración | *Integrador de pruebas* (contexto fresco) | Suite end-to-end con fixtures |
| 12 | Verificar | *Verificador* (contexto fresco) | Veredicto CONFORME / NO CONFORME + matriz de trazabilidad |
| 13 | Integrar | Sesión principal abre PR → **🚦 Gate humano** | El humano prueba y **mergea** |

**Invariantes:**
- **Independencia (P1/P3):** quien construye ≠ quien prueba ≠ quien verifica; los evaluadores corren
  en **contexto fresco**.
- **Definición antes de construir:** el criterio de éxito (test/umbral que falla) se escribe **antes**
  del código o del modelo.
- **Gates humanos** en prototipo, spec, plan y cierre (P5). **Ningún agente cruza un gate por su
  cuenta**: lo hace la sesión principal tras la aprobación humana.

**Trazabilidad end-to-end.** La columna vertebral que une los artefactos:
```
necesidad/historia  →  criterio de aceptación  →  tarea de plan  →  evidencia en verificación
```
Toda necesidad debe estar cubierta por ≥1 criterio; todo criterio por ≥1 tarea; todo criterio con
evidencia en la verificación. Si algo no traza, el artefacto está incompleto.

> **Modelo por defecto: sin bandas.** Un incremento = una construcción completa. Endurecer por
> pasadas sucesivas (*bandas*) queda **disponible pero diferido**: se adopta solo si un incremento
> resulta demasiado grande para un ciclo.

---

## 4. Estadios de madurez

Cada estadio del eje macro tiene **objetivo**, **alcance** y **criterio de salida**. Se construye con
los incrementos de §3, aplicando mínima complejidad (E4).

### 4.1 Los tres estadios

| Estadio | Objetivo | Alcance típico | Criterio de salida (gate de madurez) |
|---|---|---|---|
| **Prototipo de alto nivel** | Validar **qué vale la pena construir** antes de invertir en ingeniería (deseabilidad y/o factibilidad, §4.2) | Simulación/experimento acotado al **camino feliz**; **desechable**, sin robustez | Hipótesis validada con evidencia + **feature freeze** (§4.4) |
| **MVP** | Primer producto **funcional** usable end-to-end que entrega valor real mínimo | **Tracer Bullet a nivel de proyecto**: slice fino que atraviesa todas las capas (datos → salida/interfaz) | El slice funciona de punta a punta y valida uso/retención real |
| **Producto evolucionado/final** | **Endurecer y ampliar**: robustez, más features, escala, calidad | Incrementos sucesivos sobre la base del MVP | Cumple los criterios de calidad/negocio definidos para "final" |

### 4.2 Dos tipos de prototipo: deseabilidad vs factibilidad

El estadio de prototipo mitiga **riesgo**, y hay dos riesgos distintos → dos tipos de prototipo:

| | **Prototipo de DESEABILIDAD** | **Prototipo de FACTIBILIDAD** |
|---|---|---|
| Pregunta | *¿Deberíamos construir esto? ¿Lo quieren?* | *¿Podemos construirlo? ¿Funciona el enfoque?* |
| Riesgo que mitiga | De **mercado / producto** | De **técnica / ejecución** |
| Forma típica | Simulación **no funcional**: mockups, wireframes, no-code, "mago de Oz" | **Spike / notebook / PoC**: lógica real sobre datos sintéticos o de muestra, código desechable |
| Mide | Comprensión del valor, interés, usabilidad, disposición a usar/pagar | Que el algoritmo/enfoque/integración produce resultados aceptables |
| Backend / datos | Falsos / simulados | Reales o de muestra, pero **sin robustez** |

**Cuál hacer primero** depende del **riesgo dominante** y del tipo de proyecto:
- Domina el **riesgo de mercado** (¿alguien lo quiere?) → **deseabilidad primero**.
- Domina el **riesgo técnico** (¿es siquiera posible?) → **factibilidad primero**. En **Ciencia de
  datos/ML** suele mandar aquí: si un modelo no alcanza utilidad mínima, lo demás no importa.
- A menudo se hacen **ambos en secuencia**: deseabilidad → factibilidad → MVP.

> **Frontera humano ↔ agente.** El prototipo de **deseabilidad** suele ser una actividad **humana / de
> diseño** (puede usar herramientas no-code) y sirve de insumo; los **agentes** de construcción entran
> típicamente desde el prototipo de **factibilidad** (spike/notebook) en adelante. El prototipo es
> **desechable**: informa, no se "gradúa" a producción — los tests y el Tracer Bullet aplican **desde
> el MVP** (por eso el prototipo no contradice NC-4/NC-5).

### 4.3 Disciplina de alcance en el prototipo (control de *scope creep*)

El prototipo se mantiene barato y rápido con reglas estrictas de alcance:

- **Timebox + Feature Freeze.** Duración tope acordada; al cerrarla se **congela** y se pasa al MVP;
  las mejoras estéticas/secundarias se posponen.
- **Camino feliz (Core Path).** Solo los flujos críticos que validan la hipótesis de valor; lo demás
  se excluye.
- **Roles/actores priorizados.** Clasificar los actores del sistema por criticidad para la hipótesis y
  diseñar solo el camino feliz de los **actores clave**. Los roles secundarios/administrativos se
  **posponen al MVP**, donde se construyen en código con plantillas/componentes prefabricados.
- **Artefactos segmentados por audiencia (*split*).** En vez de un artefacto monolítico, generar
  validaciones **especializadas por audiencia** (p. ej. una para pruebas de usabilidad con usuarios y
  otra como herramienta de demostración para clientes/aliados), cada una enfocada en su objetivo.
- **Criterio de salida cuantitativo (Gatekeeper).** Definir de antemano una métrica de éxito medible
  (p. ej. "N usuarios objetivo, ≥X% de comprensión del valor" o "el baseline alcanza ≥Y de métrica")
  que decide si se pasa al MVP.
- **Exclusiones explícitas.** Declarar por escrito qué queda fuera del prototipo, para evitar la
  parálisis por diseño.

> Agnóstico por tipo de proyecto: en software/producto el "camino feliz" son flujos de UI; en DS/ML es
> la **hipótesis de valor central** (p. ej. que la señal existe en los datos y un baseline la captura).

### 4.4 Frontera Prototipo → MVP

- El paso de estadio es un **gate de madurez duro**: se cruza solo con la **evidencia** del criterio de
  salida y una **decisión humana** (P5), y se **congela** el prototipo (feature freeze).
- El **MVP es el primer entregable funcional**: se construye como **Tracer Bullet a nivel de proyecto**
  (slice fino end-to-end, §4.1) siguiendo el ciclo de incremento de §3 (ya con tests/evaluación).
- El prototipo **no se copia-pega** al MVP: queda como **referencia/demo**; la spec y el ciclo de
  construcción reescriben la lógica con rigor (§2).

### 4.5 Reglas de transición
- No se avanza de estadio sin cruzar su **gate de madurez** (decisión humana, P5).
- Cada estadio **reutiliza** los artefactos del anterior; el prototipo no se "gradúa" tal cual.
- **Mínima complejidad** (E4, NC-2): se añade estructura/robustez solo cuando el estadio lo exige, no
  antes.

---

## 5. Agentes: arquetipos y responsabilidades

La metodología define **arquetipos** (roles agnósticos), no una flota concreta. La flota real —con
nombres y modelos— se define **al instanciar cada proyecto**, respetando estos arquetipos.

**Dos familias, según lo que producen** (como planteó el encuadre del proyecto):

- **Constructores de ENTREGABLES** — producen artefactos de definición/documentación:
  *Definidor* (definición/historias), *Especificador* (spec + criterios/umbrales), *Planificador*
  (plan de tareas), *Verificador* (auditoría contra la spec).
- **Constructores de CÓDIGO / artefactos técnicos** — producen y validan lo ejecutable:
  *Prototipador* (notebook/spike), *Probador* (tests que fallan primero), *Implementador* (código
  mínimo), *Refactorizador* (limpieza sin cambiar comportamiento), *Integrador de pruebas* (suite
  end-to-end).

**Coordinación:**
- **Sesión principal (orquestador):** analiza el objetivo, fija la estrategia, guarda su plan en la
  memoria persistente **antes** de crear subagentes (E12), y crea cada subagente con una consigna
  clara (objetivo, formato de salida, herramientas, límites).
- **Agentes de sesión:** *starter* (protocolo de inicio, solo lectura) y *closer* (protocolo de
  cierre, escribe memoria) — ya provistos por el harness.

**Independencia (P1/P3):** el arquetipo que **genera** nunca es el que **evalúa**; verificación e
integración corren en **contexto fresco**.

> La correspondencia con el ciclo de §3: *Especificador*→el *Qué* · *Probador*→criterio de éxito
> (RED) · *Implementador*→código mínimo (GREEN) · *Refactorizador*→limpieza (REFACTOR) ·
> *Integrador de pruebas* + *Verificador*→auditoría independiente (VERIFY).

---

## 6. Gates de aprobación

- **Automáticos:** criterios técnicos medibles (tests en verde, cobertura de criterios, umbrales de
  métrica alcanzados).
- **Humanos (GateKeeper):** el humano aprueba intención y alcance. Gates humanos obligatorios **tras
  el prototipo**, **tras la spec**, **tras el plan**, en el **cierre del incremento** y en cada
  **transición de estadio de madurez**.

> **La automatización llega hasta el PR; el harness nunca integra a la rama principal por su cuenta.**

---

## 7. Persistencia y trazabilidad

La fuente de verdad reside en el **filesystem**, no en la memoria de los agentes: así se **reanuda**
el trabajo entre sesiones y ante fallos (E1, E5).

| Capa | Dónde | Qué guarda |
|---|---|---|
| Proyecto / sesión | `_persistence/` | `progress` · `tasks` · `lessons` · `decisions` · `assumptions` · `constrains` |
| Por incremento | estado del incremento (según la estructura del proyecto) | máquina de estado del ciclo de vida (§3) |

- **Single Writer Rule:** cada archivo de estado tiene **un único responsable de escritura**, para
  evitar condiciones de carrera. En el plan, el responsable de cada tarea es el único que actualiza su
  estado.
- **Git y reanudación:** commit por etapa con prefijo convencional; el **push** se hace en el cierre
  de sesión (agente *closer*, respetando `auto_push`). Para retomar un incremento interrumpido, la
  sesión principal lee su estado y reinvoca al arquetipo correspondiente con contexto fresco.

---

## 8. Evaluación (dimensionada a la naturaleza de la salida)

La independencia del evaluador (P3) se cumple corriendo verificación e integración en contextos
frescos, separados de quien construye.

| Tipo de salida | Naturaleza | Cómo se evalúa |
|---|---|---|
| **Código determinista** | Objetiva | **Tests** + **veredicto binario** (CONFORME/NO CONFORME) + matriz de trazabilidad |
| **Salida de ML / probabilística** | Cuantitativa/estadística | **Umbrales de métrica** sobre validación + **N corridas** midiendo consistencia (pass-rate + varianza) + rúbrica **0.0–1.0** calibrada (E3) donde no haya métrica objetiva |
| **Entregables documentales** (spec, plan, informe) | Semiestructurada | **Conformidad determinista** (¿sigue la plantilla y traza?) + **juez LLM** calibrado solo donde el juicio es semántico |

**Evaluación temprana (E9).** Al completar el primer componente funcional, evaluar una muestra de
**~20 casos representativos** (sintéticos, incl. **defectos sembrados** en ML); si la calidad es baja,
ajustar la spec **antes** de continuar.

> **Regla de corte:** la **conformidad determinista** (¿siguió el procedimiento?) es en vivo, por
> invocación, sin LLM; la **evaluación con juez** (¿el resultado es bueno?) es offline y por lotes, y
> solo arranca cuando la capa determinista es confiable y existe un dataset de fixtures.

---

## 9. Evolución del harness (E4: Mínima Complejidad)

El sistema parte del **mínimo viable** y evoluciona:
- Se construye con el **menor número de componentes** que satisfagan el trabajo (E4, NC-2).
- Cada componente codifica una **suposición explícita** sobre una limitación del modelo; no se agrega
  sin evidencia de que su ausencia degrada la calidad.
- **Prueba de remoción periódica:** quitar un componente a la vez y medir el impacto; si la calidad no
  cae, se elimina y se registra la lección en `lessons.md`.
- Conforme los modelos mejoran, algunos componentes se vuelven obsoletos y emergen nuevas capacidades
  que justifican otros nuevos.

---

## 10. Observabilidad y conformidad de los agentes (E13, P8)

Mientras §8 evalúa **el producto**, aquí se observa y audita **el comportamiento de los agentes** que
lo construyen. Aplica a **todo subagente de construcción**.

- **Traza por invocación.** Cada subagente deja registro de su secuencia de herramientas,
  entradas/salidas, tiempos y costo (tokens). La traza es la fuente de verdad de *qué hizo*; el
  auto-reporte del agente es narrativa, **no** evidencia.
- **Conformidad determinista.** Las Reglas Vinculantes del prompt de cada agente se traducen en
  **checks verificables** sobre (traza + artefacto), evaluados automáticamente en cada invocación:
  responden *¿siguió el procedimiento?* (p. ej.: leyó el contrato antes de escribir; un solo `Write`
  al artefacto que le toca; respeta la plantilla; Single Writer).
- **Conformidad ≠ calidad.** La conformidad (procedimiento) se separa del juicio semántico de calidad
  (juez LLM, §8), que solo aplica donde la salida es probabilística y no verificable mecánicamente.

> Sin esta capa, un fallo de comportamiento solo se detecta por inspección humana ad hoc, nunca de
> forma sistemática. El motor de traza/conformidad se construye **una sola vez** y es genérico; a cada
> agente se le añade su **perfil de conformidad**.

---

## Apéndice: Estándares de Ingeniería

- **Convención de commits:** `tipo(<incremento>): descripción`
  (`feat`/`spec`/`plan`/`test`/`refactor`/`verify`/`chore`/`docs`).
- **Estrategia de ramas:** cada incremento se construye en su rama; la integración a la rama principal
  es **solo vía Pull Request** tras el veredicto CONFORME. **El harness nunca integra a la principal
  por su cuenta** (detalle en `AGENTS.md` / `CLAUDE.md`).
- **Selección de modelos (P6, escalamiento proporcional):** el modelo se ajusta a la exigencia de la
  tarea —modelos más capaces para definición/spec/plan/verificación (razonamiento crítico), modelos de
  ejecución para construir/probar, y modelos ligeros para tareas simples (p. ej. el *starter* de
  sesión). Las asignaciones concretas se fijan al instanciar el proyecto.

> **Pendiente de instanciación.** La estructura física de carpetas para artefactos por incremento y
> plantillas (`_template/`) se concreta al montar un proyecto real; esta metodología define el
> **flujo, los gates, los artefactos y los roles**, no una numeración de carpetas fija.
