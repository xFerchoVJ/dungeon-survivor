# Progreso de aprendizaje — Dungeon Survivor

**Estados:** `No iniciado` · `En progreso` · `Completado` · `Requiere repaso`

> Una tarea pasa a `Completado` solo cuando yo lo confirmo o cuando verificamos el resultado juntos. No se asume que entiendo un concepto solo porque el juego corre.

## Resumen
| ID | Tarea | Fase | Estado |
|---|---|---|---|
| T01 | Git, pixel art y layers con nombre | M0 | Completado |
| D01 | Mapa de assets (delegada) | M0 | En progreso |
| T02 | `TileSet` 16x16 con colisión de paredes | M0 | No iniciado |
| D02 | Cuarto de pruebas (delegada) | M0 | No iniciado |
| T03 | Escena `Player` y movimiento | M1 | No iniciado |
| T04 | Mirada, rebote y Y-sort | M1 | No iniciado |
| C01 | Flujo del daño | M2 | No iniciado |
| T05 | Espada: pivote, hitbox y animación | M2 | No iniciado |
| T06 | Input de ataque y cooldown | M2 | No iniciado |
| T07 | Escena `Enemy`, vida y muerte | M2 | No iniciado |
| T08 | Flash y knockback | M2 | No iniciado |
| T09 | Persecución y máquina de estados | M3 | No iniciado |
| T10 | Daño al jugador, i-frames y parpadeo | M3 | No iniciado |
| T11 | HUD de vida | M3 | No iniciado |
| T12 | Muerte y game over | M3 | No iniciado |
| D03 | Layout de los 3 cuartos (delegada) | M4 | No iniciado |
| T13 | Aparición de enemigos | M4 | No iniciado |
| T14 | Cuarto limpio y puerta | M4 | No iniciado |
| T15 | Autoload `GameState` y siguiente cuarto | M4 | No iniciado |
| T16 | Victoria y reinicio completo | M4 | No iniciado |
| T17 | `Resource` `Upgrade` | M5 | No iniciado |
| D04 | Archivos de mejoras (delegada) | M5 | No iniciado |
| T18 | Pantalla "elige 1 de 3" con pausa | M5 | No iniciado |
| T19 | Aplicar mejoras | M5 | No iniciado |
| T20 | Segundo enemigo con embestida (recortable) | M6 | No iniciado |
| T21 | Menú principal y sonido | M6 | No iniciado |
| C02 | Balance | M6 | No iniciado |
| C03 | Revisión final | M6 | No iniciado |

## Detalle por tarea
Plantilla (se copia a cada tarea cuando se empieza):

```
### Txx — Título
- **Estado:** No iniciado
- **Fechas:** inicio / fin
- **Qué aprendí:**
- **Qué implementé por mi cuenta:**
- **Trabajo delegado:** (si aplica)
- **Dificultades:**
- **Dudas pendientes o conceptos por reforzar:**
- **Verificación o evidencia:**
```

## Pendientes heredados de proyectos anteriores
- Autoload (música o estado entre escenas): se practica en T15.
- `move_toward` para frenado suave: se practica en T08.
- `class_name` para tipar referencias a nodos con scripts propios: se practica desde T07.
- Buses de audio: T21.
- Por qué `set_deferred` al cambiar propiedades físicas dentro de una señal: T05 y T14.
- Explicar con mis palabras `delta`, `is_on_floor()` y `RayCast2D`: no aplican a este juego; quedan como repaso opcional.

### T01 — Git, pixel art y layers con nombre
- **Estado:** Completado (confirmado por mí el 2026-10-19)
- **Fechas:** inicio / fin 2026-10-19
- **Qué aprendí:**
- **Qué implementé por mi cuenta:** configuración de viewport 320x180 con override 1280x720, filtro Nearest, layers de física con nombre (`world`, `player`, `enemy`, `player_hitbox`, `enemy_hitbox`), carpetas `scenes/`, `scripts/`, `ui/`, `git init`.
- **Trabajo delegado:** ampliación de `.gitignore` y primer commit (`b889a6a`).
- **Dificultades:** las layers no estaban guardadas en `project.godot` en la primera revisión; se guardaron después.
- **Dudas pendientes o conceptos por reforzar:**
- **Verificación o evidencia:** `project.godot` revisado (sección `[layer_names]`); commit `b889a6a`.

*(Las demás secciones por tarea se añaden aquí conforme se trabajan.)*
