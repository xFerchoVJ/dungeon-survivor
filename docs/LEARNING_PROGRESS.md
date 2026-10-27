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
| C01 | Flujo del daño | M2 | Completado |
| T05 | Espada: pivote, hitbox y animación | M2 | Completado |
| T06 | Input de ataque y cooldown | M2 | Completado |
| T07 | Escena `Enemy`, vida y muerte | M2 | Completado |
| T08 | Flash y knockback | M2 | Completado |
| T09 | Persecución y máquina de estados | M3 | Completado |
| T10 | Daño al jugador, i-frames y parpadeo | M3 | Completado |
| T11 | HUD de vida | M3 | Completado |
| T12 | Muerte y game over | M3 | Completado |
| D03 | Layout de los 3 cuartos (delegada) | M4 | Completado |
| T13 | Aparición de enemigos | M4 | Completado |
| T14 | Cuarto limpio y puerta | M4 | Completado |
| T15 | Autoload `GameState` y siguiente cuarto | M4 | Completado |
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

### C01 — Flujo del daño (compartida)
- **Estado:** Completado (confirmado por mí el 2026-10-19)
- **Decisiones:** solo la hitbox escanea (`area_entered`); la vida vive en el cuerpo con `take_damage()`; quien ataca decide su daño; un golpe cuenta una vez porque la hitbox solo está activa durante el golpe.
- **Verificación o evidencia:** diagrama y tabla de layers/masks en `docs/TASK_BACKLOG.md`.

### T05 — Espada: pivote, hitbox y animación
- **Estado:** Completado (confirmado por mí el 2026-10-19)
- **Fechas:** inicio / fin 2026-10-19
- **Qué aprendí:** `reset_on_save` de `AnimationPlayer` aplica la animación `RESET` a los nodos al guardar, así que `RESET` es la fuente de verdad de los valores de reposo.
- **Qué implementé por mi cuenta:** `SwordPivot` que rota con `facing.angle()`, `Sword` con sprite y `Hitbox` (layer `player_hitbox`, mask `enemy`), animación `attack` de 0.25 s con pistas de `rotation`, `visible` y `monitoring` (activa de 0.05 a 0.18 s), disparo temporal con `ui_accept`.
- **Trabajo delegado:** ninguno.
- **Dificultades:** la escena quedó guardada con valores de reposo equivocados (rotación 30°, `monitoring = true`) por el `RESET`; se corrigió.
- **Dudas pendientes o conceptos por reforzar:** `set_deferred` no hizo falta aquí (la animación cambia `monitoring` fuera de la física); se practica en T14. El disparo temporal con `is_action_pressed` se reemplaza en T06.
- **Verificación o evidencia:** `player.tscn` y `player.gd` revisados; probado en el editor con el `Speed Scale` bajo y la pestaña Remoto.

### T06 — Input de ataque y cooldown
- **Estado:** Completado (confirmado por mí el 2026-10-19)
- **Fechas:** inicio / fin 2026-10-19
- **Qué aprendí:** diferencia entre `is_action_pressed` (cada frame) e `is_action_just_pressed` (solo el frame de la pulsación); el cooldown como estado de un `Timer` (`is_stopped()`).
- **Qué implementé por mi cuenta:** acción `attack` (clic izquierdo), nodo `AttackCooldown` (`one_shot`, 0.4 s), función `attack()` que reproduce la animación e inicia el `Timer`, y separé `flip_player` y `apply_bounce_animation`.
- **Trabajo delegado:** ninguno.
- **Dificultades:** empecé con `is_action_pressed`, que encadenaba golpes al mantener el clic; se cambió a `just_pressed`.
- **Dudas pendientes o conceptos por reforzar:** tipar los parámetros de `flip_player` y `apply_bounce_animation`.
- **Verificación o evidencia:** `player.gd` revisado en disco; probado en el editor (un clic, un golpe; mantener no repite; el cooldown bloquea).

### T07 — Escena `Enemy`, vida y muerte
- **Estado:** Completado (confirmado por mí el 2026-10-19)
- **Fechas:** inicio / fin 2026-10-19
- **Qué aprendí:** hurtbox pasiva (`Area2D` con layer `enemy` y mask 0); `area_entered` entrega la hurtbox, no el cuerpo, así que el dueño es su padre; `class_name Enemy` para usar `is Enemy`.
- **Qué implementé por mi cuenta:** `scenes/enemy.tscn` (cuerpo, sprite del cíclope, hurtbox), `scripts/enemy.gd` con `max_health`, `health` y `take_damage()`, `damage` exportado en `Player`, manejador `_on_hitbox_area_entered` conectado a la hitbox de la espada, enemigo estático en `test_room.tscn`.
- **Trabajo delegado:** ninguno.
- **Dificultades:**
- **Dudas pendientes o conceptos por reforzar:** tipar `_ready()` con `-> void` y la variable del dueño de la hurtbox; quitar el `print` de prueba; `position_hitter` se usa en T08.
- **Verificación o evidencia:** `enemy.tscn`, `enemy.gd` y `player.gd` revisados; probado en el editor (2 golpes con `damage = 50` y `max_health = 100`).

### T08 — Flash y knockback
- **Estado:** Completado (confirmado por mí el 2026-10-19)
- **Fechas:** inicio / fin 2026-10-19
- **Qué aprendí:** `Vector2.move_toward` para frenar el empuje; flash con `Tween` sobre `modulate`, cancelando el tween anterior para que el color no quede pegado; `move_and_slide()` en el enemigo para respetar las paredes.
- **Qué implementé por mi cuenta:** `knockback_strength` y `knockback_friction` exportados, `_physics_process` que frena `velocity`, empuje en dirección contraria al atacante con `position_hitter`, flash rojo de 0.2 s con `apply_damage_tween()`.
- **Trabajo delegado:** ninguno.
- **Dificultades:**
- **Dudas pendientes o conceptos por reforzar:** el `_physics_process` actual frena `velocity` siempre; en T09 convivirá con la persecución mediante el estado `HURT`. El flash es un tinte rojo; probar un color con valores mayores que 1 si se quiere un destello.
- **Verificación o evidencia:** `enemy.gd` revisado; probado en el editor (empuje desde varios lados, paredes, golpes seguidos).

### T09 — Persecución y máquina de estados
- **Estado:** Completado (confirmado por mí el 2026-10-20)
- **Fechas:** inicio / fin 2026-10-20
- **Qué aprendí:** máquina de estados con `enum` y `match` (`IDLE`, `CHASE`, `HURT`) donde cada estado es dueño de `velocity`; grupos (`get_first_node_in_group`) para localizar al jugador sin rutas frágiles; `direction_to()` (dirección) frente a `distance_to()` (magnitud); por qué el knockback se pisaba en `CHASE` y cómo `HURT` lo resuelve; salida de `HURT` por velocidad (`is_zero_approx()`); `take_damage()` corre completa antes de que ocurra otra cosa, así que el orden interno no evita golpes dobles (sí importa poner primero los `return` que cortan el flujo).
- **Qué implementé por mi cuenta:** nodo `Player` en el grupo `player`, rama `CHASE` con `direction_to()` por `chase_speed`, rama `HURT` con fricción y regreso a `CHASE` (o `IDLE` si no hay jugador), cambio a `HURT` en `take_damage()`, detección por `distance_to()` contra `detection_radius`.
- **Trabajo delegado:** ninguno.
- **Dificultades:** usé `distance_to` donde hacía falta `direction_to`, y asigné solo `velocity.x`; el `if` de jugador inválido no cortaba el flujo y habría accedido a `null`.
- **Dudas pendientes o conceptos por reforzar:** una vez en `CHASE` el enemigo no vuelve a `IDLE` al alejarse el jugador (decisión de diseño sin resolver; si se agrega salida, usar un radio de salida mayor que el de entrada para evitar oscilación). Hay una fricción redundante en `_process_chase` cuando no hay jugador. El archivo se reorganizó con funciones auxiliares (`_process_*`, `_apply_friction`); conviene poder explicar cada una con mis palabras.
- **Verificación o evidencia:** `enemy.gd` revisado en disco; probado en el editor (quieto fuera del radio, persecución dentro, empuje sin persecución, regreso a persecución, golpes seguidos sin quedar en `HURT`).

### T10 — Daño al jugador, i-frames y parpadeo
- **Estado:** Completado (confirmado por mí el 2026-10-20)
- **Fechas:** inicio / fin 2026-10-20
- **Qué aprendí:** `Timer` `one_shot` como estado de invulnerabilidad: no corre hasta que se llama a `start()`, y `is_stopped()` sirve de guardia; `area_entered` solo se emite al empezar a solaparse, así que un jugador quieto no recibe daño repetido; `get_overlapping_areas()` consulta lo que está solapado ahora; comparar con `is` (tipo) y no con `==` (instancia contra clase); parpadeo con `Tween` en bucle que se corta con la señal `timeout` y restaura `modulate`.
- **Qué implementé por mi cuenta:** `HurtBox` en `Player` (layer `player`, mask 0) y `HitBox` en `Enemy` (layer `enemy_hitbox`, mask `player`), `health`/`max_health` y `take_damage()` en el jugador con i-frames (`HitCooldown`), parpadeo con `Tween` y `reset_tween()` conectado a `timeout`, `damage` exportado en el enemigo, y daño por contacto con polling de `get_overlapping_areas()` (el enemigo no daña mientras está en `HURT`).
- **Trabajo delegado:** ninguno.
- **Dificultades:** comparé instancia con clase (`== Player`), el `Timer` de i-frames no se arrancaba, y dejé una conexión de señal apuntando a un método borrado.
- **Dudas pendientes o conceptos por reforzar:** al llegar a vida 0 `take_damage()` se sigue llamando cada frame y repite el `print` (se resuelve en T12). `position_hitter` del jugador aún no se usa. El polling revisa cada frame; aceptable con pocos enemigos.
- **Verificación o evidencia:** `player.gd`, `enemy.gd`, `player.tscn` y `enemy.tscn` revisados en disco; probado en el editor (un golpe por contacto, sin daño durante i-frames, el parpadeo termina, un jugador quieto vuelve a recibir daño).

### T11 — HUD de vida
- **Estado:** Completado (confirmado por mí el 2026-10-21)
- **Fechas:** inicio / fin 2026-10-21
- **Qué aprendí:** señal tipada `health_changed(actual, max)` para que el jugador no conozca al HUD; el cuarto hace de intermediario y conecta ambos; el callback debe aceptar los argumentos que envía la señal; los hijos corren `_ready()` antes que el padre, así que la señal inicial del jugador se emite antes de conectar y hay que pintar el valor inicial una vez; `CanvasLayer` queda fijo respecto a la cámara; `ProgressBar` se estiliza con `StyleBoxFlat` en los theme overrides `background` y `fill`.
- **Qué implementé por mi cuenta:** `scenes/hud.tscn` y `scripts/hud.gd` (`class_name Hud`, `update_bar()`), señal `health_changed` en `Player` emitida en `_ready()` y en `take_damage()`, `scripts/test_room.gd` que conecta la señal y pinta el valor inicial, barra verde con fondo oscuro y sin porcentaje.
- **Trabajo delegado:** ninguno.
- **Dificultades:** el callback no recibía los argumentos de la señal; el valor inicial se emitía antes de la conexión; la barra medía 4x27 px.
- **Dudas pendientes o conceptos por reforzar:** el parámetro `max` de la señal oculta la función `max()` (renombrar). La instancia se llama `hud` en `test_room.tscn` y la raíz `Hud`. Queda un `theme_override_colors/font_color` sin efecto en la barra (el texto está oculto). Opcional: color según la vida restante.
- **Verificación o evidencia:** `hud.gd`, `hud.tscn`, `test_room.gd`, `player.gd` revisados en disco; probado en el editor (barra llena al iniciar, baja con cada golpe, respeta los i-frames, queda fija).

### T12 — Muerte y game over
- **Estado:** Completado (confirmado por mí el 2026-10-21)
- **Fechas:** inicio / fin 2026-10-21
- **Qué aprendí:** la bandera `is_dead` corta `take_damage()` para que la muerte se procese una sola vez; señal `died` para que el jugador avise y el cuarto decida qué sigue; `await get_tree().create_timer(...).timeout` para una pausa sin detener el juego; `set_physics_process(false)` para congelar nodos; `get_nodes_in_group()` para actuar sobre todos los enemigos; `change_scene_to_file()` carga una escena nueva y deja el estado inicial sin resetear variables a mano; `CenterContainer` y `VBoxContainer` para centrar la UI.
- **Qué implementé por mi cuenta:** `is_dead`, señal `died` y `die()` en `Player`; `_on_died()` en `test_room.gd` (congela jugador y enemigos, espera 1 s y cambia de escena); grupo `enemies` en `enemy.tscn`; `scenes/game_over.tscn` y `scripts/game_over.gd` con botón de reinicio.
- **Trabajo delegado:** ninguno.
- **Dificultades:**
- **Dudas pendientes o conceptos por reforzar:** el guarda `is_dead` conviene que vaya antes que el de `hit_cooldown` en `take_damage()`. La ruta de `test_room.tscn` está fija en `game_over.gd`; en T15/T16 el reinicio pasará por `GameState`. Foco del botón con `grab_focus()` para usar teclado o control (opcional). Renombrar el parámetro `max` de `health_changed`.
- **Verificación o evidencia:** `player.gd`, `test_room.gd`, `game_over.gd`, `game_over.tscn`, `enemy.tscn` revisados en disco; probado en el editor (muerte única sin errores, jugador y enemigos congelados, pantalla tras ~1 s, reinicio con vida completa, segunda muerte y reinicio).

### T13 — Aparición de enemigos
- **Estado:** Completado (confirmado por mí el 2026-10-21)
- **Fechas:** inicio / fin 2026-10-21
- **Qué aprendí:** `preload` carga la `PackedScene` una vez; `instantiate()` crea el nodo pero no está en el juego hasta `add_child()`; los enemigos cuelgan del cuarto (`self`) y no de `current_scene`, para que se liberen con él y el script sirva cuando el cuarto se cargue dentro de otra escena (T15); `global_position` se asigna después de `add_child()`, con el nodo ya en el árbol, para que la posición sea correcta aunque el cuarto no esté en el origen; un solo script en la raíz sirve para los tres cuartos porque comparten la estructura `EnemySpawns/Spawn*`.
- **Qué implementé por mi cuenta:** `scripts/room.gd` (`ENEMY_SCENE`, `@onready` de `EnemySpawns`, bucle sobre los `Marker2D` que instancia, agrega y posiciona cada `Enemy`), asignado a `Room1`, `Room2` y `Room3`.
- **Trabajo delegado:** ninguno.
- **Dificultades:** primera versión con `add_child` en `current_scene` y `global_position` antes de agregar al árbol (funcionaba solo por coincidencia); `room_2` y `room_3` no tenían el script asignado.
- **Dudas pendientes o conceptos por reforzar:** el bucle tipa los hijos como `Marker2D`; si alguien agrega otro tipo de nodo bajo `EnemySpawns`, falla. `room.gd` aún no conecta la señal `health_changed` ni maneja `died` (eso sigue en `test_room.gd`); en T14/T15 habrá que decidir dónde vive. Los enemigos nacen en `_ready()`, así que en T15 el jugador ya estará en el cuarto cuando aparezcan.
- **Verificación o evidencia:** `room.gd` y los `.tscn` de los tres cuartos revisados en disco; probado en el editor (2, 3 y 4 enemigos en `room_1`, `room_2` y `room_3`, cada uno sobre su marcador).

### D03 — Layout de los 3 cuartos (delegada)
- **Estado:** Completado (confirmado por mí el 2026-10-24)
- **Trabajo delegado:** `scenes/room_1.tscn`, `room_2.tscn` y `room_3.tscn` con paredes, hueco de puerta y `Marker2D` de aparición bajo `EnemySpawns`.
- **Verificación o evidencia:** usados y probados en el editor durante T13 y T14 (2, 3 y 4 enemigos por cuarto).

### T14 — Cuarto limpio y puerta
- **Estado:** Completado (confirmado por mí el 2026-10-24)
- **Fechas:** inicio / fin 2026-10-24
- **Qué aprendí:** contar enemigos vivos con la señal `died` de cada uno (`enemies_alive`) en lugar de `get_child_count`; el cuarto conecta la señal al instanciar; la puerta desactiva su colisión con `set_deferred` cuando termina la animación `open` (señal `animation_finished`).
- **Qué implementé por mi cuenta:** `scenes/door.tscn` y `scripts/door.gd` (`class_name Door`, `open()`), `enemies_alive` y `_on_enemy_died()` en `room.gd`; además adelanté parte de T15: el cuarto instancia al `Player` en `PlayerSpawn`, y conecta `health_changed` y `died` con el `Hud`.
- **Trabajo delegado:** ninguno.
- **Dificultades:**
- **Dudas pendientes o conceptos por reforzar:** `return` sobrante al final de `_on_enemy_died()`. Si un cuarto no tiene marcadores, `enemies_alive` queda en 0 y la puerta nunca se abre. Tipar el parámetro de `_on_died(player)` y renombrar `max_health` en `_on_health_changed`. La ruta de `game_over.tscn` está fija en `room.gd`; en T15/T16 pasará por `GameState`.
- **Verificación o evidencia:** `room.gd` y `door.gd` revisados en disco; probado en el editor (la puerta se abre al morir el último enemigo en los 3 cuartos).

### T15 — Autoload `GameState` y siguiente cuarto
- **Estado:** Completado (confirmado por mí el 2026-10-27)
- **Fechas:** inicio / fin 2026-10-27
- **Qué aprendí:** `change_scene_to_file()` destruye la escena actual con el `Player`, así que el estado que debe sobrevivir vive en un autoload; un autoload puede ser un script suelto (Godot crea un `Node`, le pone el script y lo cuelga de `root`) y el `*` en `project.godot` lo expone como variable global; diferencia entre autoload (instancia única ya creada) y `class_name` (un tipo para declarar variables); `_ready()` corre solo una vez, por eso el reinicio es una función propia (`reset()`); los valores iniciales de las variables del autoload deben coincidir con lo que deja `reset()`; `add_child(player)` ejecuta el `_ready()` del jugador, que pone `health = max_health`, así que la vida guardada se asigna después; asignar `health` directo no emite `health_changed`, por eso el HUD se actualiza a mano.
- **Qué implementé por mi cuenta:** `scripts/game_state.gd` registrado como autoload `GameState` (`LEVEL_PATHS`, `actual_room`, `actual_health_player`, `is_new_match`, `reset()`); señal `player_outside` en `Door` emitida desde `ExitArea`; en `room.gd`, `_on_player_outside()` (guarda la vida, marca `is_new_match = false`, avanza `actual_room` y cambia de escena) y `update_health_player_game_state()` (aplica la vida guardada y actualiza el HUD); `GameState.reset()` en `game_over.gd` antes de volver a `room_1`.
- **Trabajo delegado:** ninguno.
- **Dificultades:** escribí `ready()` en vez de `_ready()` (nadie la llamaba); `is_new_match` empezaba en `false`, así que el primer arranque habría leído vida 0; puse `is_new_match = false` al entrar al cuarto en vez de al guardar la vida; el orden entre `add_child` y la asignación de la vida.
- **Dudas pendientes o conceptos por reforzar:** en el cuarto 3, `_on_player_outside()` hace `return` y la puerta no hace nada (se resuelve en T16, victoria). `LEVEL_PATHS` podría llamarse `ROOM_PATHS` por consistencia. `update_health_player_game_state()` también modifica la vida del jugador; un nombre como `apply_saved_health` sería más claro, y `hud.update_bar` se repite en ambas ramas. Tipar `get_first_node_in_group` con `as Player` es opcional.
- **Verificación o evidencia:** `game_state.gd`, `door.gd`, `room.gd`, `game_over.gd` y `project.godot` revisados en disco; probado en el editor (cuarto 1 con barra llena; vida conservada y jugador en `PlayerSpawn` en los cuartos 2 y 3; tras game over, cuarto 1 con barra llena y vida conservada correctamente al avanzar de nuevo; consola sin errores).

*(Las demás secciones por tarea se añaden aquí conforme se trabajan.)*
