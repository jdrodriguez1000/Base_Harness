# Constraints

> Restricciones firmes que acotan el proyecto: técnicas, de negocio, legales, de tiempo o de recursos.
> A diferencia de [[assumptions]], una restricción NO es negociable dentro del alcance actual.
> A diferencia de [[decisions]], no es una elección nuestra: es una condición impuesta.

## Índice

> Mantener sincronizado: al registrar una restricción, añadir su fila aquí.
> Buscar por ID (`C-XXX`) para localizar la restricción sin leer todo el archivo.

| ID | Restricción | Tipo | Fecha |
|---|---|---|---|
| C-001 | El harness debe ser agnóstico al proyecto y al agente | técnica | 2026-07-17 |
| C-002 | Los protocolos de inicio/cierre deben ejecutarse siempre vía su agente especializado (`sesion-starter`/`sesion-closer`), nunca invocando el skill directamente desde la sesión principal | proceso | 2026-07-17 |

## Formato

```
### C-001 — <restricción>
- **Tipo:** técnica | negocio | legal | tiempo | recursos
- **Descripción:** en qué consiste la restricción.
- **Origen:** quién o qué la impone.
- **Implicación:** cómo condiciona el trabajo.
- **Fecha:** YYYY-MM-DD
```

---

## Restricciones

### C-001 — El harness debe ser agnóstico al proyecto y al agente
- **Tipo:** técnica
- **Descripción:** No puede acoplarse a un stack, lenguaje o herramienta de IA específica; debe funcionar con Claude Code, Codex, opencode y Gemini.
- **Origen:** Requisito fundacional del proyecto.
- **Implicación:** Evitar dependencias propietarias; preferir formatos abiertos (Markdown, archivos de texto) y una fuente única de verdad reutilizable.
- **Fecha:** 2026-07-17

### C-002 — Los protocolos de inicio/cierre se ejecutan siempre vía su agente especializado
- **Tipo:** proceso
- **Descripción:** La sesión principal no debe invocar directamente los skills `startup-protocol`/`closing-protocol`. Debe delegar en el agente correspondiente: `sesion-starter` para el inicio, `sesion-closer` para el cierre.
- **Origen:** Feedback explícito del usuario en esta sesión.
- **Implicación:** `CLAUDE.md` de la raíz documenta esta vía como obligatoria; cualquier ejecución futura de los protocolos debe pasar por el agente, no por el skill directo. Ver [[decisions]] D-006.
- **Fecha:** 2026-07-17
