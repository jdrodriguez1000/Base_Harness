---
name: register-harness
description: >-
  Audita la portabilidad del harness a otra herramienta de agente (Codex, opencode, Gemini).
  Revisa qué hace falta para que los agentes y skills de sesión (inicio/cierre) puedan usarse en la
  herramienta destino, comparando la fuente de verdad (`.claude/`) con las ubicaciones y formatos
  que esa herramienta espera. Úsalo cuando el usuario diga "registrar harness", "register harness",
  "¿qué falta para usar el harness en opencode/codex/gemini?" o vaya a cambiar de herramienta.
  MODO ACTUAL: solo AUDITA e informa (no escribe nada). Herramienta soportada por ahora: opencode.
---

# register-harness — Auditoría de portabilidad del harness

Objetivo: decir **qué hace falta** para que los agentes y skills de sesión del harness
(`startup-protocol` / `closing-protocol` y sus agentes `sesion-starter` / `sesion-closer`) se
puedan usar en otra herramienta de agente. En esta iteración **solo audita** (lectura); no crea ni
modifica archivos. La provisión automática se abordará en una iteración posterior.

## Principio: fuente única de verdad

La base principal del harness es **Claude Code**. Por tanto, la fuente canónica es:

- Skills: `.claude/skills/startup-protocol/SKILL.md`, `.claude/skills/closing-protocol/SKILL.md`
- Agentes: `.claude/agents/sesion-starter.md`, `.claude/agents/sesion-closer.md`
- Instrucciones agnósticas: `AGENTS.md` (con ambos protocolos en línea)

Todo lo demás se considera un **reflejo generado** desde esta fuente. La auditoría nunca propone
editar el destino a mano, sino alinearlo con la fuente.

---

## Paso 0 — Preparación

1. Ubicarse en la raíz del proyecto.
2. **Verificar la fuente de verdad.** Comprobar que existen los 4 archivos canónicos y `AGENTS.md`.
   Si falta alguno de la fuente, reportarlo primero: sin fuente no hay nada que portar.
3. **Determinar la herramienta destino.** Si el usuario no la indicó, preguntar. Soportada por
   ahora: **opencode**. (Codex y Gemini quedan para próximas iteraciones.)

---

## Paso 1 — Auditar destino: opencode

opencode busca sus componentes en estas ubicaciones (verificado en su documentación):

| Componente | Ubicación en opencode | ¿Contenido reutilizable desde la fuente? |
|---|---|---|
| Instrucciones | `AGENTS.md` (raíz del proyecto) | Sí — mismo archivo agnóstico |
| Skills | `.opencode/skills/<nombre>/SKILL.md` | **Sí** — mismo formato `SKILL.md`; se copia el contenido |
| Agentes | `.opencode/agents/<nombre>.md` | Parcial — requiere **traducir el frontmatter** |

Revisar (solo lectura) la presencia de cada elemento y anotar ✅ presente / ❌ falta:

### 1.1 Baseline universal
- [ ] `AGENTS.md` existe en la raíz **y** contiene el "Protocolo de inicio" y el "Protocolo de
      cierre" en línea. (Es el respaldo que funciona aunque no haya skills/agentes nativos.)

### 1.2 Skills de opencode
- [ ] `.opencode/skills/startup-protocol/SKILL.md`
- [ ] `.opencode/skills/closing-protocol/SKILL.md`
  > El contenido sale tal cual de `.claude/skills/<nombre>/SKILL.md` (formato compatible).

### 1.3 Agentes de opencode
- [ ] `.opencode/agents/sesion-starter.md`
- [ ] `.opencode/agents/sesion-closer.md`
  > Requieren traducir el frontmatter de Claude → opencode (ver tabla de mapeo abajo).

### Tabla de mapeo de frontmatter (Claude → opencode)

| Claude (`.claude/agents/*.md`) | opencode (`.opencode/agents/*.md`) |
|---|---|
| nombre de archivo = id | nombre de archivo = id (igual) |
| `description` | `description` (igual) |
| `model` | `model` (igual; revisar id del proveedor) |
| `color` | *(no existe → se descarta)* |
| `tools: A, B, C` | `tools:` como mapa/objeto según formato opencode |
| *(cuerpo = prompt)* | `mode: subagent` + cuerpo = `prompt` |

---

## Paso 2 — Reporte de auditoría

Presentar al usuario una tabla clara con el estado, por ejemplo:

```
Auditoría del harness para opencode
-----------------------------------
[✅/❌] AGENTS.md con protocolos en línea (baseline)
[✅/❌] .opencode/skills/startup-protocol/SKILL.md
[✅/❌] .opencode/skills/closing-protocol/SKILL.md
[✅/❌] .opencode/agents/sesion-starter.md
[✅/❌] .opencode/agents/sesion-closer.md
```

Para cada ❌, indicar:
- **Qué falta** y su ubicación destino.
- **De dónde saldría** (archivo fuente en `.claude/` o `AGENTS.md`).
- **Qué transformación** necesita (copia directa para skills; traducción de frontmatter para agentes).

Cerrar con un resumen: *"opencode está LISTO"* (todo ✅) o *"faltan N elementos"* con la lista.

> **No escribir nada.** Si el usuario quiere provisionar los faltantes, ese es un paso aparte
> (futura iteración de este skill). Aquí solo se informa.

---

## Extensibilidad (próximas iteraciones)

Para añadir otra herramienta, replicar el Paso 1 con su mapa de ubicaciones:

- **Codex:** skills en `.agents/skills/<n>/SKILL.md` (formato compatible); agentes en
  `~/.codex/agents/*.toml` (TOML, a nivel de usuario) o solo skills.
- **Gemini:** instrucciones en `GEMINI.md`; comandos en `.gemini/commands/*.toml` (por verificar).

---

## Reglas invariantes

- **Solo auditar:** este skill NO crea ni modifica archivos en esta iteración.
- La **fuente de verdad** es `.claude/` (+ `AGENTS.md`); el destino es un reflejo, nunca al revés.
- Idioma: comunicarse en el idioma del proyecto (por defecto, español).
