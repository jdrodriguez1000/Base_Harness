# Protocolo de Git — procedimiento operativo

> Fuente única de verdad de **cómo** se opera git en el harness. La metodología dice *qué* debe
> ocurrir (`methodology.md` §7: «commit por etapa con prefijo convencional; el push se hace en el
> cierre de sesión») y el Apéndice fija la **convención**; este documento fija el **procedimiento**
> que ejecutan los skills.
>
> Los skills de etapa **no reimplementan** lo que aquí se define: lo **aplican**, pasando su etapa.
> Cambiar la conducta git del harness se hace en este archivo, no en cuatro copias.

---

## 1. Por qué existe el commit por etapa

Cada etapa produce un **artefacto que otro agente consume** (el extracto alimenta la entrevista, el
log alimenta al writer, el discovery alimenta al Prototipador). Sin commit por etapa, el trabajo de
una cadena completa vive en el árbol de trabajo sin punto de retorno: si la etapa siguiente corrompe
un artefacto, no hay a dónde volver. El commit por etapa es lo que hace **reanudable** la cadena
(E1, E5), no un trámite de higiene.

---

## 2. Bootstrap del repositorio

Se ejecuta **antes del commit de etapa** (§3), en cualquier skill que vaya a confirmar. Es
**idempotente**: si el repo ya existe, no hace nada.

1. Comprobar si el proyecto es repo git (`git rev-parse --git-dir`).
2. **Si no lo es:** ejecutar `git init` e **informar al humano** en el resumen de la etapa
   («repositorio inicializado»). No se detiene el flujo: un descubrimiento no debe quedar bloqueado
   por infraestructura, pero tampoco correr entero sin control de versiones.
3. **No se toca el remoto.** `origin` y `push` son competencia del cierre de sesión
   (`closing-protocol` Paso 6), que los deriva de `repository` en `project.yaml`.

> **Motivo (L-009).** Una prueba end-to-end completa recorrió las cuatro etapas sobre un directorio
> que ni siquiera era repo git, y ningún paso lo detectó. El bootstrap existe para que ese silencio
> no vuelva a ser posible.

---

## 3. Commit de etapa

**El disparador es la salida de etapa, no la aprobación.** En cuanto el artefacto de la etapa queda
escrito, la etapa confirma —haya gate humano o no, se haya cruzado o no:

1. `git add -A`
2. `git commit` con el mensaje del §4, **marcado `[sin confirmar]`** si el artefacto sigue en borrador
   (gate pendiente, saltado o rechazado).
3. **Reportar** hash corto y rama en el resumen de la etapa.
4. **No hacer `push`.** El push es del cierre de sesión y respeta `repository.auto_push`.

Si el gate se cruza **después** (el humano aprueba en la misma sesión o en otra), la aprobación
produce **su propio commit** —el que marca el artefacto como cerrado—, esta vez sin el marcador. El
historial queda con los dos estados y se puede volver a cualquiera.

Si no hay nada que confirmar (`git status` limpio), no es un error: informar y seguir.

> **Motivo (L-013).** Condicionar el commit a la aprobación hace que **saltarse el gate se lleve por
> delante el control de versiones**: sin aprobación no hay commit, y la etapa entera queda sin punto
> de retorno. Son dos preocupaciones distintas y no deben compartir disparador — el gate gobierna
> **si el artefacto es válido**; el commit gobierna **si el trabajo es recuperable**. Un borrador
> confirmado y rotulado es siempre preferible a un borrador perdido.

### 3.1 Checkpoints intra-etapa

Una etapa puede ser larga (una entrevista de veinte preguntas, un bucle de construcción de varias
iteraciones). Esperar a su cierre para confirmar deja horas de trabajo sin punto de retorno: si la
sesión se corta a mitad, se pierde todo lo elicitado o construido. Por eso se confirma **también dentro**
de la etapa.

**Unidad de checkpoint: el bloque natural, no el paso atómico.**

| Etapa | Confirma cada… | **No** cada… |
|---|---|---|
| `interview` | bloque de preguntas respondidas, o al interrumpirse | Q&A suelto |
| `prototype` | iteración del bucle que deja algo ejecutable | edición de archivo |

`ingest` y `discovery` **no llevan checkpoints intra-etapa**: su artefacto se escribe en una sola pasada
(el análisis previo ocurre en contexto, sin tocar disco), así que no hay estado intermedio que salvar.
Su primer commit —el del borrador recién escrito, §3— ya cumple esa función.

Confirmar por cada paso atómico produce un historial ilegible —cien commits de una línea— y no aporta
reanudabilidad real: se reanuda desde el último bloque coherente, no desde media pregunta. Confirmar
solo al cerrar la etapa es el extremo opuesto y el que de verdad duele.

- **Mensaje:** el mismo de la etapa (§4), con `[sin confirmar]`, porque un checkpoint es por definición
  trabajo en curso. Que se repita entre checkpoints es correcto: el historial refleja el bucle real.
- **Los checkpoints son siempre locales.** No se empuja ninguno. El `push` ocurre **una vez**, en el
  cierre de sesión (`closing-protocol`), respetando `repository.auto_push` (D-033).

> **Por qué locales.** El remoto es el registro que otros ven; un bucle de trabajo a medias no es algo
> que publicar a cada paso. El checkpoint resuelve **reanudabilidad** (local basta), no **compartir**
> (eso lo decide el cierre de sesión). Mezclar ambas cosas convertiría cada bloque de preguntas en un
> push, y `auto_push` dejaría de significar nada.

---

## 4. Convención del mensaje

Formato del Apéndice de `methodology.md`:

```
tipo(<alcance>): descripción
```

- **`tipo`** ∈ `feat` · `spec` · `plan` · `test` · `refactor` · `verify` · `chore` · `docs`.
- **`<alcance>`** es el **incremento** en curso. En el estadio de **Prototipo** todavía no hay
  incrementos: el alcance es `prototipo`.
- **descripción** en minúscula, imperativa y concreta: nombra el artefacto producido, no la actividad.

### Marcador de borrador

Si el artefacto se confirma **sin haber cruzado su gate**, la descripción **termina** en
`[sin confirmar]`:

```
docs(prototipo): entregable de descubrimiento [sin confirmar]
```

Va al final y literal —no `(borrador)`, no `WIP`— para que un `git log --grep` lo encuentre. Sin él,
un borrador confirmado sería indistinguible en el historial de uno aprobado, que es justamente lo que
el gate quiere evitar; **con** él, la distinción se conserva sin sacrificar el punto de retorno.

Las etapas **sin gate** (`interview`) nunca lo llevan. Cuando el gate se cruza después, el commit de
aprobación lleva el mismo mensaje **sin** el marcador.

### Etapa → tipo y artefacto

| Etapa (skill) | Mensaje | Artefacto confirmado |
|---|---|---|
| `ingest-protocol` | `docs(prototipo): extracto del documento del cliente` | `_prototype/document_extract.md` |
| `interview-protocol` | `docs(prototipo): log de entrevista de descubrimiento` | `_prototype/interview_document.md` |
| `discovery-protocol` | `docs(prototipo): entregable de descubrimiento` | `_prototype/discovery.md` |
| `prototype-protocol` | `feat(prototipo): camino feliz del generador` | `_prototype/prototype/` |

La entrevista es **append-only y reanudable**: si se cierra en varias sesiones, cada tramo confirma
con el mismo mensaje. El historial refleja el bucle real, no un cierre ficticio.

---

## 5. Lo que este protocolo **no** hace

- **No empuja.** `push` solo en `closing-protocol`, según `repository.auto_push`. Vale para **todos** los
  commits que produce este protocolo: los de etapa (§3) y los checkpoints intra-etapa (§3.1). Todo queda
  **local** hasta el cierre de sesión (D-033).
- **No crea ramas.** La estrategia de ramas (una por incremento) aplica desde el estadio de MVP; el
  Prototipo trabaja en la rama actual.
- **No integra a la principal.** La integración es **solo vía Pull Request** tras veredicto CONFORME.
  **El harness nunca integra a la principal por su cuenta** (Apéndice de `methodology.md`).
- **No reescribe historia.** Nada de `rebase`, `reset --hard` ni `--force` por iniciativa del agente.
