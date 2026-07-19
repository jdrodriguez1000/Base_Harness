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

Al **cerrar** una etapa —después de que su artefacto quede escrito y, si la etapa tiene gate humano,
después de la aprobación—:

1. `git add -A`
2. `git commit` con el mensaje del §4.
3. **Reportar** hash corto y rama en el resumen de la etapa.
4. **No hacer `push`.** El push es del cierre de sesión y respeta `repository.auto_push`.

Si no hay nada que confirmar (`git status` limpio), no es un error: informar y seguir.

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

- **No empuja.** `push` solo en `closing-protocol`, según `repository.auto_push`.
- **No crea ramas.** La estrategia de ramas (una por incremento) aplica desde el estadio de MVP; el
  Prototipo trabaja en la rama actual.
- **No integra a la principal.** La integración es **solo vía Pull Request** tras veredicto CONFORME.
  **El harness nunca integra a la principal por su cuenta** (Apéndice de `methodology.md`).
- **No reescribe historia.** Nada de `rebase`, `reset --hard` ni `--force` por iniciativa del agente.
