# Lessons Learned

> Conocimiento acumulado: errores cometidos, cómo se resolvieron y qué hacer distinto.
> Objetivo: que ningún agente repita un error ya resuelto en una sesión anterior.

## Índice

> Mantener sincronizado: al registrar una lección, añadir su fila aquí.
> Buscar por ID (`L-XXX`) para localizar la lección sin leer todo el archivo.

| ID | Lección | Fecha |
|---|---|---|
| L-001 | Duplicar `.claude/` (raíz vs `template/.claude/`) autocontiene el entregable pero crea riesgo de desincronización | 2026-07-17 |
| L-002 | En opencode, skills y subagentes compiten por su `description`; el subagente no se activa si le faltan las frases naturales del usuario | 2026-07-17 |
| L-003 | El inventario de agentes/skills de `register-harness` está hardcodeado y no crece solo cuando se añaden arquetipos nuevos al molde | 2026-07-19 |
| L-004 | Documentar un gate humano en `AGENTS.md` no lo implementa: hay que verificar el `SKILL.md` que lo ejecuta | 2026-07-19 |

## Formato

```
### L-001 — <título de la lección>
- **Contexto:** qué se estaba haciendo.
- **Problema:** qué salió mal o qué no era obvio.
- **Solución / aprendizaje:** qué funcionó y por qué.
- **Cómo aplicarlo:** regla accionable para el futuro.
- **Fecha:** YYYY-MM-DD
```

---

## Lecciones

### L-001 — Duplicar `.claude/` (raíz vs `template/.claude/`) autocontiene el entregable pero crea riesgo de desincronización
- **Contexto:** Se copiaron (no movieron) `.claude/agents` y `.claude/skills` de la raíz a `template/.claude/` para que el entregable `template/` fuera autocontenido y usable de forma independiente.
- **Problema:** Al haber dos copias físicas de los mismos skills/agentes, cualquier cambio futuro en la raíz (correcciones, nuevas versiones) no se propaga automáticamente a `template/.claude/`, y viceversa. Sin disciplina o automatización, ambas copias pueden divergir silenciosamente.
- **Solución / aprendizaje:** Se documentó explícitamente que la raíz es la fuente de verdad y `template/.claude/` es un reflejo; se registró como tarea pendiente (T-002) evaluar un script de re-copia.
- **Cómo aplicarlo:** Antes de dar por cerrada una sesión que tocó skills/agentes, verificar si `template/.claude/` necesita re-sincronizarse; no asumir que un cambio en la raíz ya se refleja en el entregable.
- **Fecha:** 2026-07-17

### L-002 — En opencode los skills y subagentes compiten por su `description`
- **Contexto:** Tras provisionar el harness en opencode, el usuario dio la instrucción "iniciemos la sesión" esperando que se activara el subagente `sesion-starter`, pero se ejecutó directamente el skill `startup-protocol`.
- **Problema:** En opencode, un subagente se invoca automáticamente **según su `description`** (o manualmente con `@nombre`), igual que un skill. Ambos compiten por la misma intención del usuario. La `description` de `sesion-starter` no contenía la frase natural "iniciemos la sesión" (solo "protocolo de inicio", "ponte al día", etc.), así que el agente principal eligió el skill, que sí matcheaba mejor.
- **Solución / aprendizaje:** Enriquecer la `description` de los agentes con las **frases naturales** que el usuario realmente dice ("iniciemos/cierra la sesión", etc.) y marcarlos como punto de entrada preferido. Alternativa siempre disponible en opencode: forzar el subagente con `@sesion-starter` / `@sesion-closer`.
- **Cómo aplicarlo:** Al crear o traducir un agente cuya activación deba ganarle a un skill homónimo, front-loadear en su `description` los disparadores literales del usuario. La `description` no es decorativa: es el criterio de enrutamiento.
- **Fecha:** 2026-07-17

### L-003 — El inventario de `register-harness` está hardcodeado y no crece solo con nuevos arquetipos
- **Contexto:** Durante T-025 (ruta documental del Descubridor, D-027) se añadió un tercer agente (`onboarding-reader`) y un tercer skill (`ingest-protocol`) al molde. Al revisar `register-harness` para planificar T-023 (re-sync a opencode/Gemini) se detectó que su lista de "qué auditar/provisionar" está **hardcodeada** en el propio `SKILL.md` y hoy solo enumera los agentes de sesión (`sesion-starter`/`sesion-closer`); nunca incluyó a `onboarding-interviewer`/`onboarding-writer`/`prototype-builder`, ni ahora a `onboarding-reader`.
- **Problema:** Cada vez que se añade un arquetipo nuevo al molde (`template/.claude/agents` + `.../skills`), `register-harness` no lo detecta automáticamente: hay que acordarse de ampliar su inventario a mano. Si no se hace, el skill audita/provisiona de forma incompleta sin avisar que algo falta en su propia lista.
- **Solución / aprendizaje:** Antes de re-ejecutar `register-harness` para sincronizar una herramienta destino, verificar que su inventario interno cubre **todos** los agentes/skills existentes en `template/.claude/`, no solo los de sesión. T-023 ya quedó ampliada para exigir esta revisión explícitamente.
- **Cómo aplicarlo:** Al crear un agente/skill nuevo deliverable-only en `template/.claude/` (D-022), añadirlo también al inventario de `register-harness` en la misma sesión (o dejarlo anotado como deuda explícita en `tasks.md`), en vez de asumir que el skill los descubre solo.
- **Fecha:** 2026-07-19

### L-004 — Documentar un gate humano en `AGENTS.md` no lo implementa
- **Contexto:** Al escribir la nueva sección "Arranque de proyecto" en `AGENTS.md` (D-028) se documentó que "entre el paso 3 y el 4 hay un gate humano" (cierre del discovery antes de pasar al Prototipador). Al verificar el `SKILL.md` que realmente ejecuta ese paso (`discovery-protocol`), resultó **falso**: el procedimiento decía "marcar el entregable como cerrado" sin pedir aprobación explícita al humano. Se encontró el mismo defecto en `interview-protocol`: cerraba la entrevista por su cuenta, sin esperar el OK del humano.
- **Problema:** Un gate humano descrito en la documentación de alto nivel (`AGENTS.md`) puede no existir en la práctica si el procedimiento operativo (`SKILL.md`) que lo ejecuta no lo implementa. La documentación y la ejecución pueden divergir silenciosamente incluso dentro de la misma sesión en que se escribió la documentación.
- **Solución / aprendizaje:** Se corrigió `discovery-protocol` (su Paso 2.3 ahora pide aprobación explícita del humano y el entregable queda en borrador hasta obtenerla, + regla invariante nueva) y `interview-protocol` (propone el cierre y espera el OK del humano en vez de cerrar por su cuenta).
- **Cómo aplicarlo:** Cada vez que se documente un "gate humano" (o cualquier paso de aprobación) en un archivo de alto nivel (`AGENTS.md`, `methodology.md`), verificar el `SKILL.md` operativo correspondiente para confirmar que efectivamente pide y espera esa aprobación, en vez de asumir que la mención documental basta.
- **Fecha:** 2026-07-19
