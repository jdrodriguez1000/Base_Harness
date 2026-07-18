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

## Tabla de contenidos

La navegación interna del documento usa los **números de sección** (§X) que aparecen en las
referencias cruzadas.

| § | Sección | Qué contiene |
|---|---|---|
| **0** | Propósito y Mapa de fuentes | Para qué existe la metodología y qué tiene dueño canónico fuera de aquí |
| **1** | Los dos ejes del trabajo | Madurez (macro) e incremento (micro): el avance "de menos a más" |
| **2** | Tipos de proyecto y su adaptación | Espina común de fases; software vs Ciencia de datos/ML |
| **3** | Ciclo de vida de un incremento | Las 11 fases del ciclo, gates humanos y trazabilidad end-to-end |
| 3.1 | · Observabilidad y evaluación del ciclo TDD | Cómo el test es contrato, evidencia y oráculo en código |
| **4** | Estadios de madurez | Prototipo de alto nivel → MVP → Producto final |
| 4.1 | · Los tres estadios | Objetivo, alcance y criterio de salida de cada uno |
| 4.2 | · Deseabilidad vs factibilidad | Los dos tipos de prototipo y cuál va primero |
| 4.3 | · Disciplina de alcance | Control de *scope creep* en el prototipo |
| 4.4 | · Frontera Prototipo → MVP | El gate de madurez duro |
| 4.5 | · Reglas de transición | Cómo se pasa de un estadio al siguiente |
| **5** | Agentes: arquetipos y responsabilidades | Familias de arquetipos y coordinación (flota agnóstica) |
| 5.1 | · Contrato de un constructor de entregables | Plantilla → instancia → relleno → gate |
| 5.2 | · Revisor de código | Evaluador independiente de calidad/seguridad (adoptar por E4) |
| 5.3 | · Especialización de flota | Frontend/backend y otras variantes de instanciación |
| **6** | Gates de aprobación | Gates automáticos vs humanos (GateKeeper) |
| **7** | Persistencia y trazabilidad | Filesystem como fuente de verdad; Single Writer |
| 7.1 | · Estado por incremento (`state.yaml`) | Máquina de estado de la slice: espina única + capas etiquetadas |
| **8** | Evaluación | Cómo se evalúa el **producto** según la naturaleza de la salida |
| 8.1 | · Flujo de evaluación (ejemplo) | Las tres capas de evaluación de un entregable |
| **9** | Evolución del harness | Mínima complejidad (E4) y prueba de remoción |
| **10** | Observabilidad y conformidad | Cómo se audita el **comportamiento** de los agentes |
| 10.1 | · Flujo end-to-end (ejemplo) | Recorrido desde la invocación hasta la conformidad |
| — | Apéndice | Estándares de ingeniería (commits, ramas, modelos) |

> **Gatillo de división (pendiente).** Mientras el documento quepa cómodo en un archivo, se mantiene
> unido con esta tabla. Si el bloque de **agentes/evaluación/observabilidad** (§5, §8, §9, §10, +§3.1)
> supera por sí solo ~250 líneas, o si casi siempre editas solo ese bloque, **dividir** en
> `methodology.md` (proceso: §1–§4, §6, §7) + `agents-and-evaluation.md` (§5, §8, §9, §10; §3.1 se
> mueve con un puntero desde §3).

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
`Definir → Especificar → Planear → Construir → Verificar → Integrar`

| Fase | Software | Ciencia de datos / ML |
|---|---|---|
| Definir | Intención + historias de la funcionalidad | Pregunta/objetivo, métrica de éxito, disponibilidad de datos |
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

> **El prototipo ocurre una sola vez, al inicio.** "Prototipar" **no** es una fase del ciclo de
> incremento: cuando se construye una vertical slice se produce **funcionalidad real** (con
> tests/evaluación) que se suma poco a poco, no un prototipo. La exploración desechable
> —notebook/EDA/PoC que informa el enfoque— pertenece al **estadio de Prototipo de alto nivel** (§4),
> que se hace una vez antes del MVP. En DS/ML, esa exploración es el **prototipo de factibilidad**
> (§4.2). El notebook/PoC no se copia-pega al entregable: la spec y el ciclo de construcción reescriben
> la lógica con rigor; queda como artefacto de referencia/demo.

> **Spikes de excepción (opcional).** En un incremento avanzado puede surgir una incógnita técnica
> nueva que amerite un *spike* desechable puntual. Es una **herramienta de excepción**, no una fase del
> flujo: su código no se gradúa; solo informa la spec de ese incremento.

---

## 3. Ciclo de vida de un incremento

Ninguna pieza se produce sin una definición previa, una spec aprobada y un mecanismo de
validación. El ciclo de un incremento, con sus **gates humanos** (🚦):

| # | Fase | Responsable (arquetipo, §5) | Artefacto / Acción |
|---|---|---|---|
| 1 | Definir el incremento | Humano + sesión principal | Acuerdo de intención + rama de trabajo |
| 2 | Escribir el contrato | Sesión principal | Contrato del incremento ("estrella polar" / definición de Terminado) |
| 3 | Definir | *Definidor* | Definición (necesidades / historias) |
| 4 | Especificar | *Especificador* | Spec con criterios verificables (y umbrales, en ML) |
| 5 | **🚦 Gate humano** | Humano | Aprueba / rechaza la spec |
| 6 | Planear | *Planificador* | Plan de tareas + casos de test/evaluación |
| 7 | **🚦 Gate humano** | Humano | Aprueba / rechaza el plan |
| 8 | Construir | *Probador* → *Implementador* → *Refactorizador* | RED → GREEN → REFACTOR (+ evaluación en ML) |
| 9 | Probar integración | *Integrador de pruebas* (contexto fresco) | Suite end-to-end con fixtures |
| 10 | Verificar | *Verificador* (contexto fresco) | Veredicto CONFORME / NO CONFORME + matriz de trazabilidad |
| 11 | Integrar | Sesión principal abre PR → **🚦 Gate humano** | El humano prueba y **mergea** |

**Invariantes:**
- **Independencia (P1/P3):** quien construye ≠ quien prueba ≠ quien verifica; los evaluadores corren
  en **contexto fresco**.
- **Definición antes de construir:** el criterio de éxito (test/umbral que falla) se escribe **antes**
  del código o del modelo.
- **Gates humanos** en spec, plan y cierre (P5). **Ningún agente cruza un gate por su
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

### 3.1 Observabilidad y evaluación del ciclo TDD (código)

En **código bajo TDD**, el **test cumple tres papeles a la vez** —contrato de forma, evidencia de
conformidad y oráculo de evaluación—, así que observabilidad (§10) y evaluación (§8) **se entrelazan**
en el bucle en vez de ir por capas separadas. Intervienen tres agentes en cadena, distintos entre sí
(P1/P3): *Probador* (RED), *Implementador* (GREEN), *Refactorizador* (REFACTOR); luego, en **contexto
fresco**, *Integrador de pruebas* y *Verificador*.

**Observabilidad — la disciplina TDD es verificable por la traza:**
```
 PROBADOR (RED)             escribe test → CORRE → ✗ FALLA
   conformidad: el test FALLA antes de existir código · NO tocó código de producción
 IMPLEMENTADOR (GREEN)      escribe código → CORRE → ✓ PASA
   conformidad: el test ahora PASA · solo tocó producción (no el test) · alcance mínimo · Single Writer
 REFACTORIZADOR (REFACTOR)  limpia → CORRE → ✓ SIGUE VERDE
   conformidad: verde antes y después · sin nuevos tests ni cambio de comportamiento
```
El check imposible de falsear: **hubo una corrida en ROJO antes de la corrida en VERDE**. Si el test
pasó a la primera, no se siguió TDD → **NO CONFORME** aunque el resultado final sea verde.

**Evaluación — el test es el oráculo objetivo (sin juez LLM):**
```
 1. DETERMINISTA: suite en VERDE · cada criterio → ≥1 test (matriz §3) · linters + complejidad (refactor)
 2. ¿LOS TESTS VALEN?  mutation testing / DEFECTOS SEMBRADOS: inyecta bugs → ¿la suite se pone roja?
       (equivalente en código a "calibrar el juez" de los documentos, §8.1)
 3. INTEGRACIÓN:  Integrador de pruebas (contexto fresco) — ¿lo nuevo rompe lo existente?
 4. VERIFICACIÓN: Verificador (contexto fresco) — CONFORME/NO CONFORME vs spec + matriz de trazabilidad
 5. GATE HUMANO 🚦 — el humano prueba y mergea (solo vía PR, P5)
```
Un **test verde puede mentir** (un test que no afirma nada pasa siempre); por eso la **capa 2**
(mutantes) evalúa que los tests **valgan**, no solo que existan.

> **Documento vs código.** En documentos el contrato de forma es la **plantilla** (§5.1) y el oráculo es
> un **juez LLM** calibrado (semántico); en código el contrato es el **test que falla** y el oráculo son
> los **tests** (binario, objetivo, sin LLM). En ambos, "**defectos sembrados**" valida al evaluador
> (juez LLM ↔ mutation testing) y la **independencia** (evaluador ≠ constructor, contexto fresco) es
> idéntica.

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

> **Frontera humano ↔ agente.** El **descubrimiento** (entender cliente, stakeholders, actores y camino
> feliz) lo **conduce un agente** —el *Descubridor* (§5)— entrevistando al humano. La **materialización**
> del prototipo de deseabilidad (mockups, wireframes, "mago de Oz") sigue siendo una actividad **humana /
> de diseño**; los agentes de **construcción** entran de lleno desde la **factibilidad** (spike/notebook)
> en adelante. El prototipo es **desechable**: informa, no se "gradúa" a producción — los tests y el
> Tracer Bullet aplican **desde el MVP** (por eso el prototipo no contradice NC-4/NC-5).

### 4.3 Disciplina de alcance en el prototipo (control de *scope creep*)

El prototipo se mantiene barato y rápido con reglas estrictas de alcance:

- **Timebox + Feature Freeze.** Duración tope acordada; al cerrarla se **congela** y se pasa al MVP;
  las mejoras estéticas/secundarias se posponen.
- **Camino feliz (Core Path).** Solo los flujos críticos que validan la hipótesis de valor; lo demás
  se excluye.
- **Roles/actores priorizados (taxonomía por defecto).** Clasificar los actores por criticidad y
  diseñar **solo el camino feliz** de cada uno. Como *lente de elicitación* —un **piso, no un techo**—
  todo sistema se examina contra al menos **tres arquetipos de actor**, definidos por su relación con el
  valor (no por su cargo):
  - **Generador** — origina el valor central por su **uso directo**; es la **razón de ser** (sin
    generador no hay sistema).
  - **Operador** — **aprovecha lo que el generador produce** y lo convierte en valor posterior.
  - **Administrador** — **sostiene y gobierna** el sistema (altas/bajas, configuración, métricas) sin
    participar del flujo de valor central.

  **Siempre se pregunta por los tres**, pero pueden **faltar o colapsar** (sin operador, sin
  administrador, ambos en un mismo actor, o los tres concentrados en el generador); se declara
  explícitamente cuáles existen. **Prioridad no lineal:** el camino feliz del **generador es obligatorio**
  para arrancar el proyecto; los de operador y administrador se construyen **bajo demanda** (cuando la
  aplicación lo requiera —días o semanas después—), **no** en una secuencia inmediata tras el generador.
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

> **El generador basta para avanzar.** Un proyecto puede pasar al **MVP con solo el camino feliz del
> generador** construido; las funciones de operador y administrador se cubren provisionalmente con un
> **humano que simula la aplicación (mago de Oz, §4.2)** hasta que su construcción se justifique. Es
> **mínima complejidad (E4)** aplicada al eje de actores: se construye el actor crítico y se **difiere o
> simula** el resto, sin bloquear la entrega de valor.

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
- **Constructores y evaluadores de CÓDIGO / artefactos técnicos** — producen y validan lo ejecutable:
  *Probador* (tests que fallan primero), *Implementador* (código mínimo), *Refactorizador* (limpieza
  sin cambiar comportamiento), *Integrador de pruebas* (suite end-to-end), *Revisor de código*
  (evaluación independiente de calidad/seguridad/diseño — §5.2).

> **Descubridor (estadio de Prototipo, fuera del ciclo de incremento).** Antes de prototipar, alguien
> tiene que **preguntar**. El *Descubridor* **conduce la entrevista con el humano/cliente** para elicitar
> qué quiere el cliente, los **stakeholders**, los **actores** (taxonomía de §4.3) y el **camino feliz de
> cada actor**. Se distingue del resto en que su insumo no es un artefacto previo sino el **diálogo con el
> humano**. **Alcance acotado (crítico):** busca un entendimiento **rápido y suficiente para arrancar**
> —lo justo para prototipar el camino feliz del **generador**—, no un relevamiento exhaustivo; evita el
> cuestionario infinito que lleva a la **parálisis por diseño** (§4.3). **Produce** un *entregable de
> descubrimiento* (actores clasificados con ausencias/colapsos declarados, camino feliz por actor,
> stakeholders y el **Gatekeeper** de §4.3), que es el **insumo del Prototipador**. Como constructor de
> entregables sigue el contrato de §5.1 y es **observable y evaluable** (perfil de conformidad §10 +
> rúbrica §8).

> **Prototipador (fuera del ciclo de incremento).** El **estadio de Prototipo de alto nivel** (§4) usa
> un *Prototipador* que toma el *entregable de descubrimiento* y construye el **camino feliz desechable**
> (spike/notebook/PoC de factibilidad) **empezando por el generador**; los demás actores, bajo demanda
> (§4.3). Es un arquetipo del **estadio inicial**, desechable, **no del ciclo de incremento**: las slices
> se construyen con los arquetipos de arriba, no con el Prototipador. Orden del estadio: **Descubridor →
> Prototipador**.

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

### 5.1 Contrato de trabajo de un constructor de entregables

Todo arquetipo que produce un **entregable documental** (definición, spec, plan, informe) opera bajo el
mismo **contrato de trabajo** de cuatro pasos. Es agnóstico al proyecto: las rutas físicas concretas se
fijan al instanciar (ver nota final). Este contrato es lo que hace **observable y verificable** a un
agente que, por ser probabilístico, no se puede dar por bueno solo con su palabra.

1. **Plantilla = contrato de forma.** Cada tipo de entregable tiene un **esqueleto versionado** en
   `_template/` (una plantilla por artefacto: definición, spec, plan…). El esqueleto fija la
   **estructura obligatoria** —secciones, campos, marcadores de relleno—: es el contrato de *forma*. El
   *qué* de contenido lo fijan el contrato del incremento y la spec.
2. **Instanciar antes de rellenar.** El agente **copia** el esqueleto a la ubicación de trabajo del
   incremento con el **nombre canónico** del artefacto — **nunca escribe desde cero**. Así todo
   artefacto **nace conforme** a su plantilla y la conformidad de estructura es verificable por **diff**
   contra el esqueleto.
3. **Rellenar sin alterar la estructura.** El agente completa/actualiza **solo el contenido** de las
   secciones; no reordena ni elimina la estructura. Rige **Single Writer** (§7): cada artefacto tiene
   **un único agente** responsable de su escritura.
4. **Reportar y ceder el gate.** Al terminar, el agente **informa** que terminó — **no cruza gates**. La
   sesión principal presenta el artefacto al **humano** para aprobación (P5). El auto-reporte es
   *narrativa, no evidencia* (§10): lo que cuenta es la **traza + el artefacto**.

> **Ejemplo (definición).** Esqueleto de `definición` en `_template/` → el *Definidor* lo **copia** como
> la definición del incremento en su ubicación de trabajo → **rellena** necesidades/historias respetando
> las secciones → **informa**; la sesión principal lo lleva al **gate humano**.

**Observabilidad y evaluación de este agente** (por ser **probabilístico**):
- **Traza por invocación (§10):** su secuencia de herramientas, entradas/salidas, tiempos y costo quedan
  registrados; es la fuente de verdad de *qué hizo*.
- **Perfil de conformidad determinista (§10):** checks automáticos sobre (traza + artefacto) que
  responden *¿siguió el procedimiento?* — p. ej.: **leyó** el contrato/insumos antes de escribir;
  **instanció** desde la plantilla (no desde cero); **respeta la estructura** del esqueleto (diff);
  **un solo `Write`** a su artefacto; **Single Writer** (no tocó artefactos ajenos).
- **Evaluación de calidad (§8):** *juez LLM* calibrado **solo** para el juicio **semántico** del
  contenido (¿las historias son correctas, completas y trazables?), offline y por lotes, cuando exista
  dataset de fixtures. **Conformidad (procedimiento) y calidad (contenido) se miden por separado.**

> El mismo contrato aplica, con su plantilla propia, a *Especificador* (spec), *Planificador* (plan) y
> al informe del *Verificador*. Los **constructores de código** (§5) no usan plantilla-esqueleto: su
> "forma" la fijan los tests y la spec, y su conformidad se audita igual vía traza (§10).

### 5.2 Revisor de código (evaluador independiente, adoptar por E4)

Los tests son un oráculo **binario y objetivo**, pero no juzgan **diseño, seguridad, mantenibilidad ni
casos borde que nadie testeó** (un test verde puede mentir, §3.1). El *Revisor de código* cubre ese
hueco: es el **análogo en código del juez LLM** de los documentos —la capa de **juicio semántico** sobre
lo ejecutable.

- **Independencia (P3):** corre en **contexto fresco**, distinto del que escribió el código.
- **División con el *Verificador*:** el *Verificador* pregunta *¿cumple la spec? ¿traza?* (binario,
  requisitos); el *Revisor* pregunta *¿es buen código, seguro, completo?* (cualitativo, diseño).
  Complementarios, no redundantes.
- **Sus hallazgos vuelven como tests, no como parches:** un caso borde detectado → se escribe un **test
  que falla** → reingresa al bucle TDD (§3.1). Así el hueco se cierra de forma permanente (§9), no con
  ediciones ad hoc.
- **Adopción por E4 (§9):** no se monta de entrada. Primero lo hace el **gate humano** (revisión de PR);
  si la evidencia muestra defectos de calidad escapándose de forma sistemática, se **automatiza** como
  arquetipo. Se añade un componente cuando su ausencia degrada la calidad, no antes.

> **Hermano de seguridad.** La **revisión de seguridad** (auditoría de vulnerabilidades del código) es
> un evaluador **transversal análogo**, con las mismas reglas (independiente, contexto fresco, hallazgos
> → tests que fallan, adoptar por E4). Puede ser el mismo *Revisor* con un perfil de seguridad o un
> arquetipo `security-reviewer` aparte. **La seguridad que es *comportamiento*** (autorización,
> validación de input) **no** es revisión: es un **criterio de aceptación** en la spec (§3, paso 4).

### 5.3 Especialización de flota (instanciación)

Los arquetipos son **agnósticos**; la **flota real** puede especializarlos al instanciar cuando el
*tooling* diverge lo suficiente. Caso típico: **frontend vs backend** en el trío TDD.

- **La disciplina no cambia:** RED → GREEN → REFACTOR, conformidad e independencia son idénticas en FE
  y BE. El **arquetipo** *Probador/Implementador/Refactorizador* es el mismo.
- **Lo que difiere es el tooling y la naturaleza del test:** BE → lógica determinista
  (unit/integración/contrato); FE → suma **regresión visual, interacción/DOM, accesibilidad**, con mayor
  superficie subjetiva que se apoya más en el *Revisor de código* / humano.
- **Regla E4:** empezar con **un** trío TDD agnóstico; dividir en variantes FE/BE **solo con evidencia**
  de que un agente único rinde mal en ambos. La especialización es decisión de **flota**, no de
  arquetipo.

---

## 6. Gates de aprobación

- **Automáticos:** criterios técnicos medibles (tests en verde, cobertura de criterios, umbrales de
  métrica alcanzados).
- **Humanos (GateKeeper):** el humano aprueba intención y alcance. Gates humanos obligatorios
  **tras la spec**, **tras el plan**, en el **cierre del incremento** y en cada **transición de estadio
  de madurez** (incluida la aprobación del Prototipo de alto nivel, §4.4).

> **La automatización llega hasta el PR; el harness nunca integra a la rama principal por su cuenta.**

---

## 7. Persistencia y trazabilidad

La fuente de verdad reside en el **filesystem**, no en la memoria de los agentes: así se **reanuda**
el trabajo entre sesiones y ante fallos (E1, E5).

| Capa | Dónde | Qué guarda |
|---|---|---|
| Proyecto / sesión | `_persistence/` | `progress` · `tasks` · `lessons` · `decisions` · `assumptions` · `constrains` (narrativa, Markdown) |
| Por incremento | `state.yaml` de la slice (§7.1; ruta física según la instanciación) | máquina de estado del ciclo de vida (§3), estructurada |

- **Dos naturalezas distintas.** `_persistence/` es **narrativa** (bitácora en Markdown con `## Índice`);
  el estado de una slice es **estructurado** (§7.1), porque lo lee el orquestador para reanudar y los
  checks de conformidad (§10) para auditar.
- **Single Writer Rule:** cada archivo de estado tiene **un único responsable de escritura** para evitar
  condiciones de carrera. El `state.yaml` lo escribe **solo el orquestador**; cada **artefacto**
  (`definition`, `spec`, `plan`, código, tests) lo escribe **solo su agente productor**.
- **Git y reanudación:** commit por etapa con prefijo convencional; el **push** se hace en el cierre
  de sesión (agente *closer*, respetando `auto_push`). Para retomar un incremento interrumpido, la
  sesión principal lee su `state.yaml` y reinvoca al arquetipo del paso pendiente con contexto fresco.

### 7.1 Estado por incremento (`state.yaml`)

Cada vertical slice lleva su propia **máquina de estado del ciclo de vida** (§3) en un archivo
**estructurado** (convención `state.yaml`; la ruta física se fija al instanciar). Reglas del modelo:

- **Espina única de 11 pasos.** `state.yaml` modela **un solo** ciclo §3 (Definir → … → Integrar) con el
  estado de cada paso y el resultado de cada gate. **No se bifurca por capa técnica:** una slice es
  end-to-end (NC-4). Si algo es valor de usuario independiente end-to-end, es **otra slice** (otro
  `state.yaml`), no una rama de esta.
- **Las capas viven dentro de Construir.** Frontend, backend y base de datos **no son pasos**: son
  *tareas etiquetadas* dentro de Planear/Construir. Cada caso/tarea lleva su `component` (fe/be/db) y su
  `owner` (agente de la flota, §5.3). `definition`/`spec`/`plan` son **unificadas** para toda la slice;
  el plan las descompone por capa.
- **Construir es un bucle TDD.** Cada caso recorre **RED → GREEN → REFACTOR** (§5.3); el campo `stage`
  marca la fase. Un caso de **caracterización** (`caracterizacion: true`) es un test que **nace verde**:
  fija conducta ya existente, no dirige código nuevo.
- **Las revisiones transversales viven en Verificar.** Calidad de código (§5.2) y seguridad (su
  hermano) son **entradas de evaluación** en Verificar, no pasos nuevos. La seguridad-*comportamiento*
  es un **criterio de aceptación** en la spec.
- **Los gates dejan traza.** Cada gate humano (pasos 5, 7 y 11) registra `status`
  (`PENDIENTE`/`APROBADO`/`APROBADO_CON_CAMBIOS`/`RECHAZADO`), `fecha` y una lista de `resoluciones`
  —qué se decidió y **contra** qué alternativa—. **Ningún agente cruza un gate** (P5).
- **Escritor único:** el **orquestador** (§7). Los subagentes reportan; él verifica (§10) y transcribe.

**Carpeta del incremento.** El `state.yaml` no vive suelto: encabeza la carpeta de la slice, junto a los
artefactos que produce cada paso. La numeración de carpeta (`_increments/`, `NNN_…`) es convención del
proyecto, no obligación (ver nota del Apéndice); lo fijo es la **relación** entre el estado y sus
artefactos hermanos:

```
_increments/<id>/
├── state.yaml         ← máquina de estado (único que escribe el orquestador)
├── contract.md        ← paso 2 · estrella polar / definición de Terminado
├── definition.md      ← paso 3
├── spec.md            ← paso 4  (gate paso 5)
├── plan.md            ← paso 6  (gate paso 7)
└── verification.md    ← paso 10 · veredicto + matriz de trazabilidad
```

**Plantilla.** La forma completa (espina de 11 pasos, gate reutilizable, bucle TDD en Construir y
evaluadores en Verificar) vive en **`_templates/state_temp.yaml`**: se copia a `_increments/<id>/state.yaml`
al abrir el incremento y se rellena. Estructura esencial:

```yaml
meta:      { incremento: "<id>", rama: "<rama-git>", estado_global: in_progress, paso_actual: 8 }
pasos:                     # espina §3 — un solo ciclo, sin bifurcar por capa (NC-4)
  5_gate_spec: { status: done, gate: { status: APROBADO_CON_CAMBIOS, fecha: "<f>", resoluciones: [
    { punto: "<qué>", decision: "<qué se resolvió>", contra: "<alternativa descartada>" } ] } }
  8_construir: { status: in_progress }
construir:                 # paso 8 — bucle TDD; capas = tareas etiquetadas
  cases:
    - { id: 1, ca: [CA-01], component: backend,  owner: implementador, stage: green,   caracterizacion: false }
    - { id: 7, ca: [CA-10], component: frontend, owner: implementador, stage: pending, caracterizacion: false }
verificar:                 # paso 10 — evaluadores transversales (por E4)
  spec_verifier:   { status: pending }
  code_review:     { status: pending, archetype: code-reviewer }      # §5.2
  security_review: { status: pending, archetype: security-reviewer }  # hermano de §5.2
```

> **Reanudación y git.** El `state.yaml` vive en la **rama de la slice**; al integrar se **archiva** como
> registro de trazabilidad. Es el mecanismo que hace **reanudable** un incremento interrumpido (§7).

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

### 8.1 Flujo de evaluación (ejemplo: la *definición* de una slice)

Paralelo al flujo de observabilidad (§10.1). **Observabilidad ≠ evaluación:** la observabilidad valida
*¿siguió el procedimiento?* (el *cómo*); la evaluación valida *¿el trabajo quedó bien hecho?* (el
*qué*). Un agente puede ser **CONFORME** y aun así entregar un mal producto — eso lo caza la evaluación.

Para un **entregable documental** (definición, spec, plan) la evaluación tiene **tres capas**, de más
barata a más cara; solo sube de capa lo que la capa anterior no puede juzgar:

```
 definición ya CONFORME (pasó observabilidad §10.1)
        │
        ▼
 1. CHECK DETERMINISTA DE COMPLETITUD/TRAZABILIDAD  (script, SIN LLM, en vivo)
       ✓ ninguna sección vacía / placeholder sin llenar
       ✓ cada necesidad → ≥1 criterio de aceptación (la matriz de trazabilidad cierra, §3)
    → si falla, no llega ni al juez ni al humano
        │
        ▼
 2. GATE HUMANO  🚦  (autoritativo para ESTA instancia, P5)
        │
 ─ ─ ─ ─│─ ─ ─ ─ ─ ─ ─ ─  (en paralelo / offline, por lotes)  ─ ─ ─ ─ ─ ─ ─ ─
        ▼
 3. JUEZ DE CALIDAD (LLM) — agente DISTINTO del que escribió, contexto fresco (P3)
       - corre sobre un DATASET DE FIXTURES (casos representativos + defectos sembrados)
       - rúbrica 0.0–1.0, N corridas midiendo consistencia (pass-rate + varianza)
       - CALIBRADO contra etiquetas humanas: solo se confía donde coincide con el humano
    → mide/regresiona al Definidor; NO bloquea esta instancia
```

**Cuatro invariantes de una evaluación confiable:**
- **Independencia (P3):** quien evalúa **no** es quien escribió; corre en **contexto fresco**.
- **El juez LLM se calibra, no se cree:** se contrasta contra un **golden set** con etiquetas humanas y
  **defectos sembrados**; se usa **solo donde coincide** con el humano. Donde no, decide el humano.
- **Evaluación temprana (E9):** al primer componente funcional, ~20 casos representativos; si la calidad
  es baja, se ajusta la **spec/prompt del agente** *antes* de continuar.
- **Retroalimenta al agente, no parchea el artefacto:** una mala nota se corrige en el **prompt/spec**
  del agente para que no reaparezca (§9); el gate humano puede rechazar la instancia y pedir
  re-generación.

> **Por tipo de salida (§8).** Cambia la **capa 2**: en **código determinista** son **tests** (veredicto
> binario); en **ML/probabilístico**, **umbrales de métrica + N corridas** midiendo consistencia. El
> gate humano y la independencia son iguales en los tres.

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

### 10.1 Flujo end-to-end (ejemplo: construir la *definición* de una slice)

Quién interviene y en qué orden, desde la invocación hasta la observabilidad. Nota que **traza** y
**conformidad** son deterministas (harness/script, **sin LLM**); el **juez de calidad** es un agente
LLM que corre **aparte, offline**. Distinguen dos preguntas: *¿siguió el procedimiento?* (conformidad)
vs *¿el resultado es bueno?* (calidad).

```
 1. SESIÓN PRINCIPAL ──▶ invoca al DEFINIDOR (consigna: objetivo, plantilla, insumos)
                              │
 2. DEFINIDOR (LLM)           ▼
    a) LEE contrato del incremento + insumos
    b) COPIA  _template/definición  →  definición del incremento (nombre canónico)
    c) RELLENA necesidades/historias respetando la estructura
    d) INFORMA "terminé"                       ◀── narrativa, NO evidencia
                              │
        (durante la corrida el harness graba la TRAZA: herramientas, I/O, tiempos, costo)
                              ▼
 3. CHECKER DE CONFORMIDAD (script determinista, SIN LLM) sobre (traza + artefacto):
       ✓ ¿leyó el contrato ANTES del primer Write?
       ✓ ¿instanció desde la plantilla (no desde cero)?
       ✓ ¿la estructura coincide con el esqueleto?  (diff)
       ✓ ¿un solo Write, y solo a SU artefacto?  (Single Writer)
    → veredicto: CONFORME / NO CONFORME
                              │
              ¿CONFORME? ── NO ──▶ corrida no confiable: la SESIÓN PRINCIPAL
                              │      re-invoca o escala (nunca va al gate humano
                              │      una corrida que no siguió el procedimiento)
                             SÍ
                              ▼
 4. SESIÓN PRINCIPAL ──▶ presenta la definición al  🚦 GATE HUMANO  (aprueba/rechaza, P5)

 ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  aparte, offline, por lotes  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
 5. JUEZ DE CALIDAD (LLM), cuando hay dataset de fixtures:
       evalúa lo SEMÁNTICO (¿historias correctas, completas, trazables?) con rúbrica
       calibrada. NO bloquea el gate; mide/mejora al Definidor y ajusta la spec (§8, §9).
```

Un agente puede ser **CONFORME pero de baja calidad** (siguió el procedimiento, historias flojas) o
**NO CONFORME** (ni copió la plantilla). Por eso conformidad y calidad se miden **por separado**. El
mismo flujo aplica, con su plantilla y su perfil de conformidad, a *Especificador*, *Planificador* y al
informe del *Verificador* (§5.1).

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
