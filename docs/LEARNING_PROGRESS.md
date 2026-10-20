# Progreso de aprendizaje — Dungeon Survivor

**Estados:** `No iniciado` · `En progreso` · `Completado` · `Requiere repaso`

> Una tarea pasa a `Completado` solo cuando yo lo confirmo o cuando verificamos el resultado juntos. No se asume que entiendo un concepto solo porque el juego corre.

## Resumen
| ID | Tarea | Fase | Estado |
|---|---|---|---|
| T01 | Git, pixel art y layers con nombre | M0 | Completado |
| D01 | Mapa de assets (delegada) | M0 | Completado |
| T02 | `TileSet` 16x16 con colisión de paredes | M0 | Completado |
| D02 | Cuarto de pruebas (delegada) | M0 | Completado |
| T03 | Escena `Player` y movimiento | M1 | Completado |
| T04 | Mirada, rebote y Y-sort | M1 | Completado |
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

### T02 — `TileSet` 16x16 con colisión de paredes
- **Estado:** Completado (confirmado por mí el 2026-10-19)
- **Fechas:** inicio / fin 2026-10-19
- **Qué aprendí:**
- **Qué implementé por mi cuenta:** `TileSet` sobre `tilemap_packed.png` (16x16, sin separación), physics layer 0 con `collision_layer = 1` (`world`) y `collision_mask = 0`, polígonos 16x16 en las paredes `(4,3)` y `(9..11,4)`, escena de prueba `scenes/test_scene.tscn`.
- **Trabajo delegado:** ninguno.
- **Dificultades:**
- **Dudas pendientes o conceptos por reforzar:** los tiles `(9..11,4)` tenían el polígono duplicado (`polygon_0` y `polygon_1`); es inofensivo, pero conviene dejar uno. El `TileSet` quedó dentro de la escena; guardarlo como `.tres` para reutilizarlo en todos los cuartos.
- **Verificación o evidencia:** revisión del `.tscn` (physics layer, polígonos solo en paredes, suelos sin colisión).

### D01 — Mapa de assets (delegada)
- **Estado:** Completado (confirmado por mí el 2026-10-19)
- **Trabajo delegado:** tabla de tiles de `tilemap_packed.png` en `CLAUDE.md`; no se modificó ningún asset.
- **Verificación o evidencia:** las coordenadas de pared usadas en T02 coinciden con la tabla.

### D02 — Cuarto de pruebas (delegada)
- **Estado:** Completado (confirmado por mí el 2026-10-19)
- **Trabajo delegado:** `scenes/test_room.tscn` (capas `Floor` y `Walls`, 20x11 tiles, perímetro cerrado), `scenes/tileset.tres` extraído de la escena de prueba (sin el polígono duplicado) y borrado de `test_scene.tscn`.
- **Verificación o evidencia:** `tile_map_data` decodificado: 220 celdas de suelo y 58 de pared, todas en el perímetro; abierto en el editor sin errores.

### T03 — Escena `Player` y movimiento
- **Estado:** Completado (confirmado por mí el 2026-10-19)
- **Fechas:** inicio / fin 2026-10-19
- **Qué aprendí:**
- **Qué implementé por mi cuenta:** acciones `move_*` (WASD) en el Input Map, `scenes/player.tscn` (`CharacterBody2D` + `Sprite2D` con región `(16,128,16,16)` + `CollisionShape2D` 12x15), `scripts/player.gd` con `Input.get_vector` y `move_and_slide()`, `speed = 60`, layer `player` y mask `world`.
- **Trabajo delegado:** ninguno.
- **Dificultades:**
- **Dudas pendientes o conceptos por reforzar:** la colisión de 12x15 es muy ajustada; si se atora en huecos de 1 tile (puertas), reducirla a ~10x10 en los pies.
- **Verificación o evidencia:** revisión de `player.tscn`, `player.gd` y `project.godot`; probado en `test_room.tscn`.

### T04 — Mirada, rebote y Y-sort
- **Estado:** Completado (confirmado por mí el 2026-10-19)
- **Fechas:** inicio / fin 2026-10-19
- **Qué aprendí:**
- **Qué implementé por mi cuenta:** `facing` que conserva la última dirección no nula, `flip_h` según `direction.x`, rebote procedural del `Sprite2D` con `sin` y asentamiento con `move_toward`, `y_sort_enabled` en `TestRoom`.
- **Trabajo delegado:** ninguno.
- **Dificultades:**
- **Dudas pendientes o conceptos por reforzar:** amplitud de 0.5 px (el pixel art no dibuja medios píxeles; probar 1 px); el rebote depende de `direction` y no de la velocidad real; reiniciar `bounce_time` al parar.
- **Verificación o evidencia:** revisión de `player.gd` y `test_room.tscn`; probado en el editor.

*(Las demás secciones por tarea se añaden aquí conforme se trabajan.)*
