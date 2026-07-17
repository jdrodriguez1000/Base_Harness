# Harness base — Guía de portabilidad (`register-harness`)

Este harness nace en **Claude Code** y está pensado para usarse también en **opencode**, **Codex** y
**Gemini**. La pieza que lo hace portable es la habilidad **`register-harness`**: audita qué falta en
una herramienta destino y, con tu confirmación, la **provisiona** (crea sus skills y agentes nativos).

> La descripción canónica y detallada del procedimiento vive en
> `.claude/skills/register-harness/SKILL.md` y su versión resumida (para el arranque desde cualquier
> herramienta) está en `AGENTS.md`, sección *Portabilidad del harness*. Este README es la guía
> práctica de uso.

---

## Fuente única de verdad

La base canónica son **archivos de texto plano** (no una app concreta). Cualquier herramienta puede
leerlos con sus tools de archivo:

| Qué | Dónde |
|---|---|
| Skills | `.claude/skills/<nombre>/SKILL.md` |
| Agentes | `.claude/agents/<nombre>.md` |
| Instrucciones agnósticas | `AGENTS.md` |

Todo lo que aparece en un destino (`.opencode/…`, etc.) es un **reflejo generado** desde esta fuente.

### Regla de oro

> Edita **siempre la fuente** (`.claude/…` o `AGENTS.md`) y luego **re-sincroniza**.
> **Nunca** edites a mano los archivos generados en el destino: son un reflejo y el próximo re-sync
> los sobrescribe. El destino refleja la fuente, **nunca al revés**.

---

## Las dos modalidades de `register-harness`

### 1. Auditar (solo lectura)

Dice **qué falta** en la herramienta destino para que el harness funcione ahí. No escribe nada.

- **Cuándo:** antes de empezar a trabajar en una herramienta nueva, o para verificar el estado.
- **Cómo invocarla:**
  - En **Claude Code:** *"registra el harness para opencode"* / *"¿qué falta para usar el harness en
    opencode?"* (dispara la habilidad).
  - En **opencode** (ya provisionado y autosuficiente): igual, la habilidad nativa responde.
  - En **una herramienta aún sin provisionar:** el agente lee la sección *Portabilidad del harness*
    de `AGENTS.md` y sigue el procedimiento a mano.
- **Resultado:** un reporte ✅/❌ por cada elemento (baseline `AGENTS.md`, skills, agentes).

### 2. Provisionar (escribe — solo con tu confirmación)

Crea en el destino **los elementos que faltan** a partir de la fuente. Antes de escribir, enumera los
archivos que va a crear y pide el visto bueno.

- **Cuándo:** la primera vez que preparas el harness en una herramienta (tras una auditoría con ❌).
- **Cómo invocarla:** *"provisiona opencode"* / *"créalos"* / confirmando tras el reporte de auditoría.
- **Qué hace:**
  - **Skills** → copia directa del `SKILL.md` (formato compatible). Incluye el propio
    `register-harness`, para que la herramienta quede **autosuficiente**.
  - **Agentes** → traduce el frontmatter al formato del destino y conserva el cuerpo como `prompt`.
- **Importante — no sobrescribe:** en modo provisión normal solo crea lo que **falta**; lo que ya
  existe **no se toca**.

#### Sub-modo: Re-sync (sobrescribir)

Para **propagar un cambio de la fuente** a un destino ya provisionado (los archivos ya existen),
pide **re-sync explícito**: *"re-sincroniza opencode"*. Esto **sí sobrescribe** el reflejo con la
versión actual de la fuente. Es el paso que cierra el ciclo "editar fuente → actualizar destino".

---

## Flujo típico: ajustar un agente o una habilidad

Estés en la herramienta que estés (incluida opencode, sin volver a Claude Code):

1. **Edita la fuente** en `.claude/` (son archivos Markdown):
   - ¿Un **agente**? → `.claude/agents/<nombre>.md`
   - ¿Una **habilidad**? → `.claude/skills/<nombre>/SKILL.md`
2. **Llama a `register-harness` en modo re-sync** (*"re-sincroniza <herramienta>"*) para que
   sobrescriba el reflejo con lo nuevo.
3. **Nunca** edites directamente los archivos del destino (`.opencode/…`): se perderían.

---

## Cuándo cambiar el **procedimiento de portabilidad**

Lo anterior cubre ajustes a agentes/skills concretos. Distinto es cambiar **cómo** se audita o
provisiona. En esos casos hay que tocar **dos sitios y mantenerlos alineados**:

1. La habilidad `.claude/skills/register-harness/SKILL.md` (procedimiento canónico).
2. La sección *Portabilidad del harness* de `AGENTS.md` (espejo para el bootstrap desde otras
   herramientas).

Cambia el procedimiento cuando:

- **Añades una herramienta destino nueva** (p. ej. Codex o Gemini): hay que definir sus ubicaciones
  nativas y su traducción de frontmatter. **Verifica antes** el formato real con documentación
  oficial; no implementes sobre supuestos.
- **Una herramienta destino cambia** su formato o sus ubicaciones (nuevos campos de frontmatter,
  rutas distintas, etc.).
- **Cambian los modelos o las tools** asignados a los agentes en un destino.
- **Añades un nuevo agente o skill al harness** que requiera una regla de traducción distinta a las
  ya documentadas.

> Motivo de los dos sitios: `AGENTS.md` es lo que **todas** las herramientas leen, así que resuelve
> el arranque (bootstrap) cuando aún no hay skill nativo; el `SKILL.md` es el detalle canónico. Si
> divergen, un agente en otra herramienta podría portar el harness de forma incorrecta.

---

## Resumen

| Quiero… | Modo | Qué digo |
|---|---|---|
| Ver qué falta en una herramienta | Auditar | *"registra el harness para \<herramienta\>"* |
| Preparar el harness por primera vez | Provisionar | *"provisiona \<herramienta\>"* |
| Propagar un cambio de la fuente | Re-sync | *"re-sincroniza \<herramienta\>"* |

**Herramienta soportada hoy:** opencode. Codex y Gemini están en el mapa, pendientes de
implementación/verificación.
