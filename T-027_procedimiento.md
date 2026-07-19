# T-027 — Procedimiento de repetición de la prueba end-to-end

> Entregable de **T-033**. Define en qué orden se aplican los ajustes, cómo se prepara la corrida y
> —lo más importante— **qué hay que observar para declarar cerrado cada hallazgo**.
>
> Motivo de existir: la corrida 1 se juzgó a ojo. Los cinco hallazgos (L-005…L-009) aparecieron por
> inspección humana ad hoc, que es exactamente lo que `methodology.md` §10 dice que ocurre sin capa de
> conformidad. Este documento escribe el criterio de éxito **antes** de la corrida, como pide §3
> (*"el criterio de éxito se escribe antes del código"*) y P5.

---

## 1. Orden de aplicación de los ajustes

Ningún paso arranca hasta que el anterior esté cerrado.

| # | Ajuste | Estado |
|---|---|---|
| 1 | **T-028** — anti-fabricación, confirmación diferida, estado `n/a` | ✅ hecho |
| 2 | **T-029** — pasada de consistencia entre áreas | ✅ hecho |
| 3 | **G3** — `ingest-protocol` instancia desde plantilla | ✅ hecho |
| 4 | **G7** — timebox acordado (interviewer + prototipador) | ✅ hecho |
| 5 | **G10** — deriva raíz↔molde de `startup-protocol` | ✅ hecho |
| 6 | **T-030 + G1 + G5** — commit por etapa, bootstrap git, `git log` al inicio, convención de commits | ✅ hecho (corrida 2) |
| 7 | **T-042** — commit desacoplado del gate; marcador `[sin confirmar]` | ✅ hecho |
| 8 | **T-043** — contrato de entrada: verificar `Estado`/`Confirmado` del insumo y avisar | ✅ hecho |
| 9 | **T-044** — `project.yaml` insumo declarado; regla de procedencia (dos clases, dos fuentes) | ✅ hecho |
| 10 | **T-041** — §7 "cubierta" = métrica + umbral + método, alineado en los tres skills | ✅ hecho |
| 11 | Sincronizar el proyecto de prueba desde `template/` | ⛔ **bloqueante de la corrida 3** |

**Por qué la corrida 2 fracasó pese a tener el paso 6 hecho:** T-030 implementó el commit por etapa pero
lo dejó **colgando del gate humano**; al saltarse el gate, no hubo commit y L-009 reapareció (L-013). Eso
es lo que corrige T-042, y por eso los pasos 7–10 son ahora precondición de la corrida 3.

**El paso 11 sigue siendo bloqueante de verdad:** el `.claude/` del proyecto de prueba es anterior a
todos estos cambios; correr sin recopiarlo mediría los skills viejos (ver §2).

---

## 2. Preparación de la corrida

**Precondición crítica.** El `.claude/` del proyecto de prueba actual es **anterior** a todos los
cambios de esta sesión. Correr sin recopiarlo mediría los skills viejos y la prueba no diría nada.

1. Proyecto de prueba **limpio**, copiado desde `template/`: `.claude/`, `_guideline/`, `_templates/`,
   `_persistence/` (vacío), `AGENTS.md`/`CLAUDE.md`/`GEMINI.md`.
2. `_prototype/` **no debe existir** al arrancar: el estadio lo inaugura el reader.
3. `_context/client_brief.md` = el fixture de reciclaje **sin modificar**. En particular:
   - el título conserva `<nombre-del-proyecto>` **sin rellenar** → es la trampa de L-005;
   - la contradicción §5 (registro *con* validación de correo) ↔ §8 (excluye validación de correo,
     también gmail/apple) **se deja intacta** → es la trampa de L-006.
   > **No se “arregla” el brief.** Su valor como fixture está justamente en sus defectos.
4. `_context/project.yaml` con `persistence.dir` y la sección `repository`.
5. **`git init` + commit inicial** antes de invocar al primer agente (precondición de T-030).

---

## 3. Criterios de aceptación por hallazgo

Cada fila se evalúa sobre **el artefacto + la traza**, no sobre lo que el agente diga que hizo.

> **Regla general — camino no ejercitado ≠ camino correcto (L-016).** Cuando un criterio se apoya en un
> evento que *puede no ocurrir* (una confirmación, un gate, un commit), **la ausencia del evento es
> fallo, no aprobado**. Un hallazgo solo se declara cerrado si su mecanismo **se ejecutó y se observó**;
> si la corrida no lo ejercitó, se registra como **no evaluado** y el hallazgo **sigue abierto**. El
> error a evitar es leer "no vi nada mal" como "está bien": son cosas distintas cuando el camino nunca
> se recorrió.

### L-005 — fabricación de un nombre inexistente

| | |
|---|---|
| **Pasa si** | `Meta · Proyecto` del extracto está en `<no declarado>`, **o** su valor aparece **literalmente** en el brief |
| **Falla si** | Aparece cualquier nombre de aplicación que no esté en el brief (p. ej. `ReciclApp`) |
| **Ojo** | `Recicladora Oriente Verde` **sí** está literal en §1, pero es el nombre de la **empresa**, no del proyecto. Ponerlo sin distinguirlo es aprobado con reparo: literal pero de referente equivocado |

### L-006 — contradicción transversal no detectada

| | |
|---|---|
| **Pasa si** | *Ambigüedades detectadas* registra la contradicción validación-de-correo, **citando ambos extremos** (§5 y §8 del brief) y nombrando las áreas en conflicto (**discovery §6 ↔ §9**) |
| **Falla si** | La ambigüedad no aparece, o aparece citando una sola cara, o el reader la **resolvió** eligiendo una lectura |
| **Es la prueba directa de T-029** — el cruce §6↔§9 es el primero de su tabla |

### L-007 — confirmación adelantada

| | |
|---|---|
| **Pasa si** | En la traza hay **dos escrituras**: la que crea el extracto lo deja en `Confirmado: no` / `Estado: borrador`, y la que pone `sí`/`cerrado` es **posterior al turno** en que el humano confirmó |
| **Falla si** | Una sola escritura deja `sí`; **o** el `sí` se escribe antes de la respuesta humana; **o** la confirmación **nunca ocurre** y el extracto termina la corrida en `no`/`borrador` |
| **Ojo** | El tercer caso de fallo es el que se pasó por alto en la corrida 2: se dio L-007 por cerrado porque nadie confirmó **antes de tiempo**, cuando en realidad **nadie confirmó nunca**. Un campo que jamás cambia de valor no es evidencia de que el mecanismo de confirmación funcione — es evidencia de que no se ejecutó. **Camino no ejercitado ≠ camino correcto** (L-016) |

### L-008 — áreas sin estado `n/a`

| | |
|---|---|
| **Pasa si** | discovery **§3** (tipo de prototipo) queda `n/a` con justificación en *Qué falta*; el interviewer **no** la pregunta; el writer la **deduce** sin declararla hueco. Igual para **§10** si el proyecto no justifica split |
| **Falla si** | §3 queda `ausente` (y entra a la agenda de entrevista), o queda `n/a` sin justificación, o el writer la marca pendiente |
| **Control inverso** | Ninguna área que **sí** le toca al cliente aparece en `n/a`. `n/a` usado como atajo es fallo aunque el resto pase |

### L-009 — sin control de versiones

| | |
|---|---|
| **Pasa si** | `git log` muestra **≥1 commit por etapa** (ingesta, entrevista, discovery, prototipo) con la convención `tipo(<incremento>): descripción`, y el inicio de sesión **leyó** `git log` (G1) |
| **Falla si** | La corrida termina con cero commits, o con un único commit al cierre, o con mensajes fuera de convención (G5) |
| **Ojo (T-042)** | El commit ya **no depende del gate**: una etapa cuyo gate se saltó debe confirmar igual, con `[sin confirmar]` al final del mensaje. Ese sufijo **es** la convención, no una violación. **Falla igual** si el gate se salta y la etapa queda sin commit — que es como reapareció L-009 en la corrida 2 (L-013) |

### G7 — timebox (nuevo, primera ejecución)

| | |
|---|---|
| **Pasa si** | *Timebox acordado* de la cabecera del log no está vacío ni en `<marcador>`, y se fijó **antes** de la primera pregunta de área. Si el cierre alega *"timebox agotado"*, el campo no puede decir `sin acordar` |
| **Idem prototipador** | Si cierra por timebox, el tope consta en §8 del discovery o en un acuerdo explícito en la traza |

---

## 4. Criterios de la corrida completa

Además de los hallazgos, la corrida debe:

1. **Completar las cuatro etapas** — reader → interviewer → writer → builder.
2. **No repreguntar lo cubierto** — ninguna entrada del log corresponde a un área `cubierta` o `n/a`.
3. **Cerrar el discovery con gate humano explícito** — `cerrado` lo autoriza la persona, no el agente.
4. **Respetar §9 en el prototipo** — y aquí está la prueba de fuego de L-006: si la contradicción no se
   detectó, el prototipo acabará **construyendo la validación de correo que §8 excluye**. Ese es el
   coste real del hallazgo, materializado. Si aparece en `_prototype/prototype/`, L-006 no está cerrado
   por mucho que el extracto luzca bien.

---

## 5. Qué hacer con los hallazgos nuevos

Esta corrida ejercita **mucha superficie de prompt que nunca se ha ejecutado**: los cuatro arreglos de
T-028/T-029, el estado `n/a` propagado a cuatro archivos, el timebox y los checks de conformidad
añadidos a los prompts. Es **esperable** que salgan hallazgos nuevos.

- Un hallazgo nuevo **no es un retroceso**: es para lo que sirve la prueba.
- Se registra como `L-0XX` con su tarea, **sin corregir el proyecto de prueba** (criterio de D-029).
- Solo se declara **fracasada** la corrida si **reaparece** alguno de L-005…L-009.

---

## 6. Registro del resultado

Al terminar, dejar en la memoria del harness:

- Una entrada de `progress.md` con el veredicto **por hallazgo** (cerrado / reabierto), no un resumen
  narrativo.
- `L-005…L-009` marcadas como verificadas en `lessons.md` si su criterio pasó.
- Los hallazgos nuevos como `L-0XX` + tareas.
