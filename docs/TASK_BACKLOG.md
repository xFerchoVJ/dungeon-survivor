# Backlog de tareas — Dungeon Survivor

**Tipos:** A = Aprendizaje (lo implemento yo) · D = Delegado (lo hace Claude con mi autorización) · C = Compartido.

> Aquí solo hay objetivo, dependencias, criterios de aceptación y errores comunes. El checklist detallado y las pistas se dan cuando empieza cada tarea. Las estimaciones son sin contar depuración.

## M0 — Preparación

### T01 — Git, pixel art y layers con nombre
- **Tipo:** A · **Est.:** 30 min · **Depende de:** nada
- **Objetivo:** dejar el proyecto listo: repositorio, resolución para pixel art y capas de física con nombre.
- **Aceptación:** `git init` y primer commit con `.gitignore` correcto; viewport 320x180 con ventana 1280x720; filtro Nearest; carpetas `scenes/`, `scripts/`, `ui/`; layers `world`, `player`, `enemy`, `player_hitbox`, `enemy_hitbox` guardadas en `project.godot`.
- **Errores comunes:** poner 1280x720 en el viewport en vez del override; que las layers no se guarden; commit con atribución (ver `CLAUDE.md`).

### D01 — Mapa de assets
- **Tipo:** D · **Est.:** — · **Depende de:** nada
- **Objetivo:** identificar en `tilemap_packed.png` qué tile (coordenada en la hoja) es cada cosa: héroe, enemigos, espada, suelos, paredes, puerta abierta y cerrada, corazón o poción.
- **Aceptación:** tabla en `CLAUDE.md` con coordenadas de atlas; no se mueve ni modifica ningún asset.
- **Errores comunes:** confundir `tilemap.png` (con 1 px de separación) con la hoja empaquetada.

### T02 — `TileSet` 16x16 con colisión de paredes
- **Tipo:** A · **Est.:** 30 min · **Depende de:** T01, D01
- **Objetivo:** crear el `TileSet` sobre `tilemap_packed.png` con physics layer `world` y polígonos solo en las paredes.
- **Aceptación:** tiles de 16x16 sin separación; paredes con colisión y suelos sin ella; layer `world` y mask 0.
- **Errores comunes:** tamaño de tile por defecto distinto de 16; poner colisión en los suelos.

### D02 — Cuarto de pruebas
- **Tipo:** D · **Est.:** — · **Depende de:** T02
- **Objetivo:** un cuarto de 20x11 tiles con paredes en el perímetro para probar movimiento y combate.
- **Aceptación:** se decodifica `tile_map_data` y el perímetro está cerrado; propuesta aprobada por mí antes de escribir.
- **Errores comunes:** editar el `.tscn` con el editor abierto (el editor sobrescribe; recargar antes de seguir).

## M1 — Jugador

### T03 — Escena `Player` y movimiento
- **Tipo:** A · **Est.:** 30 min · **Depende de:** D02
- **Objetivo:** `CharacterBody2D` con `Sprite2D` (región de la hoja) y movimiento en 8 direcciones.
- **Aceptación:** acciones propias `move_*` en el Input Map; `Input.get_vector` (diagonal igual de rápida); choca con las paredes; layer `player`, mask `world`; velocidad cómoda para 320x180.
- **Errores comunes:** usar acciones `ui_*`; velocidad excesiva; el `Sprite2D` desalineado con la colisión.

### T04 — Mirada, rebote y Y-sort
- **Tipo:** A · **Est.:** 45 min · **Depende de:** T03
- **Objetivo:** guardar `facing`, voltear con `flip_h`, dar sensación de caminar con rebote procedural y ordenar por profundidad.
- **Aceptación:** `facing` conserva la última dirección al detenerse; el sprite rebota al caminar y se asienta al parar; `y_sort_enabled` configurado.
- **Errores comunes:** que `facing` se ponga en cero al soltar las teclas; animar con `_process` en vez de `_physics_process` sin razón.

## M2 — Combate

### C01 — Flujo del daño
- **Tipo:** C · **Est.:** 20 min · **Depende de:** T04
- **Objetivo:** decidir juntos quién detecta el golpe, quién decide el daño y quién reacciona (hitbox/hurtbox, señales, layers y masks).
- **Aceptación:** un diagrama ASCII del flujo y la tabla de layers/masks acordados, anotados en este archivo.
- **Errores comunes:** mezclar hitbox y hurtbox en el mismo `Area2D`.
- **Decisiones acordadas (2026-10-19):**
  1. Solo la hitbox escanea (`area_entered`); la hurtbox es pasiva.
  2. La vida vive en el cuerpo (`Player`, `Enemy`) con un método `take_damage()`; no hay nodo `Health` aparte.
  3. Quien ataca decide su daño: el jugador tiene el valor (así las mejoras de T19 lo modifican) y lo pasa al llamar `take_damage()`. El enemigo hace lo mismo con su propio daño.
  4. Un golpe cuenta una sola vez porque la hitbox solo está activa durante el golpe y `area_entered` se emite una vez por hurtbox. No se usa lista de enemigos golpeados salvo que las pruebas muestren golpes dobles.

  ```
  Jugador ataca a un enemigo
  ────────────────────────────────────────────────────────
  Sword/Hitbox (Area2D)                Enemy/Hurtbox (Area2D)
    layer: player_hitbox (4)             layer: enemy (3)
    mask:  enemy (3)                     mask:  0 (pasiva)
          │
          │ area_entered(area)       ← detecta la hitbox
          ▼
    busca el cuerpo dueño de la hurtbox (su padre)
    cuerpo.take_damage(daño_del_jugador, posición_del_atacante)
          │
          ▼
    Enemy (CharacterBody2D)
       • resta vida              ← decide el cuerpo
       • flash + knockback       ← reacciona el cuerpo
       • queue_free() si vida <= 0

  Enemigo toca al jugador: mismo flujo con
    Enemy/Hitbox  (layer enemy_hitbox 5, mask player 2)  →  Player/Hurtbox (layer player 2, mask 0)
  ```

  | Nodo | Layer (soy) | Mask (veo) |
  |---|---|---|
  | Paredes (`TileMapLayer`) | `world` (1) | — |
  | `Player` (cuerpo) | `player` (2) | `world` (1) |
  | `Player/Hurtbox` | `player` (2) | 0 |
  | `Enemy` (cuerpo) | `enemy` (3) | `world` (1) |
  | `Enemy/Hurtbox` | `enemy` (3) | 0 |
  | Espada (hitbox) | `player_hitbox` (4) | `enemy` (3) |
  | Contacto del enemigo (hitbox) | `enemy_hitbox` (5) | `player` (2) |

  Los cuerpos de jugador y enemigo no se bloquean entre sí (sus máscaras solo incluyen `world`); el daño lo gestionan solo las `Area2D`. Las hitboxes usan `area_entered`, así que ignoran los cuerpos que comparten su layer.

### T05 — Espada: pivote, hitbox y animación
- **Tipo:** A · **Est.:** 60 min · **Depende de:** C01
- **Objetivo:** un `Node2D` pivote que rota hacia `facing`, con sprite de espada y una hitbox (`Area2D`) que un `AnimationPlayer` activa solo durante el golpe.
- **Aceptación:** el golpe sale hacia donde mira en las 4 u 8 direcciones; la hitbox solo está activa durante el golpe (visible con *Visible Collision Shapes*); layer `player_hitbox`.
- **Errores comunes:** dejar la hitbox siempre activa; cambiar `monitoring` dentro de una señal sin `set_deferred`.

### T06 — Input de ataque y cooldown
- **Tipo:** A · **Est.:** 30 min · **Depende de:** T05
- **Objetivo:** acción `attack` y un `Timer` de cooldown.
- **Aceptación:** una pulsación = un golpe; no se puede atacar durante el cooldown; mantener la tecla no ataca en bucle sin respetar el cooldown.
- **Errores comunes:** `is_action_pressed` en vez de `just_pressed`; varios `await` simultáneos.

### T07 — Escena `Enemy`, vida y muerte
- **Tipo:** A · **Est.:** 45 min · **Depende de:** T06
- **Objetivo:** `CharacterBody2D` con hurtbox (`Area2D` en layer `enemy`), vida y `queue_free()` al llegar a 0. Instancia estática en el cuarto de pruebas.
- **Aceptación:** la espada le resta vida; muere con la vida en 0; un solo golpe no cuenta varias veces; el enemigo no recibe daño de sí mismo ni del jugador sin golpe.
- **Errores comunes:** que un golpe dispare `area_entered` varias veces; guardar la vida en la hitbox.

### T08 — Flash y knockback
- **Tipo:** A · **Est.:** 45 min · **Depende de:** T07
- **Objetivo:** parpadeo de color con `modulate` y empuje que se frena con `move_toward`.
- **Aceptación:** el empuje va en dirección contraria al jugador y decae; el flash dura poco y vuelve al color normal; el enemigo no atraviesa paredes.
- **Errores comunes:** asignar `velocity` sin frenarla; dejar `modulate` pegado si llega otro golpe.

## M3 — Enemigo y vida

### T09 — Persecución y máquina de estados
- **Tipo:** A · **Est.:** 60 min · **Depende de:** T08
- **Objetivo:** estados `IDLE`, `CHASE` y `HURT` con `enum` y `match`; `direction_to` hacia el jugador.
- **Aceptación:** el enemigo persigue al jugador dentro de un radio; durante el knockback no persigue; vuelve a perseguir al terminar.
- **Errores comunes:** buscar al jugador cada frame con una ruta frágil (mejor un grupo o una referencia); cambiar de estado sin salir del anterior.

### T10 — Daño al jugador, i-frames y parpadeo
- **Tipo:** A · **Est.:** 60 min · **Depende de:** T09
- **Objetivo:** el enemigo hace daño por contacto (hitbox en layer `enemy_hitbox`); el jugador tiene vida, i-frames con `Timer` y parpadeo.
- **Aceptación:** el daño se resta una vez por contacto; durante los i-frames no recibe más; el parpadeo se ve y termina.
- **Errores comunes:** daño repetido por frame; i-frames que no terminan.

### T11 — HUD de vida
- **Tipo:** A · **Est.:** 30 min · **Depende de:** T10
- **Objetivo:** `CanvasLayer` con barra o corazones que reflejan la vida.
- **Aceptación:** el HUD se actualiza con una señal (el jugador no conoce al HUD); queda fijo respecto a la cámara.
- **Errores comunes:** que el HUD lea la vida cada frame en vez de escuchar una señal.

### T12 — Muerte y game over
- **Tipo:** A · **Est.:** 30 min · **Depende de:** T11
- **Objetivo:** a vida 0 el jugador muere, hay una pausa corta con `await` y aparece la pantalla de game over con reinicio.
- **Aceptación:** la muerte se procesa una sola vez; el reinicio deja todo en su estado inicial.
- **Errores comunes:** varias muertes encadenadas por golpes simultáneos.

## M4 — Cuartos

### D03 — Layout de los 3 cuartos
- **Tipo:** D · **Est.:** — · **Depende de:** T02
- **Objetivo:** tres escenas de cuarto con paredes, hueco de puerta y `Marker2D` para la aparición de enemigos, con pocos obstáculos.
- **Aceptación:** propuesta aprobada antes de escribir; perímetro cerrado salvo la puerta; los marcadores caen sobre suelo.
- **Errores comunes:** obstáculos donde la persecución directa se atora.

### T13 — Aparición de enemigos
- **Tipo:** A · **Est.:** 45 min · **Depende de:** D03, T09
- **Objetivo:** `preload`, `instantiate()` y `add_child()` de enemigos en los `Marker2D` al empezar el cuarto.
- **Aceptación:** cada marcador genera un enemigo en su posición; las instancias quedan como hijos del cuarto.
- **Errores comunes:** usar `position` en vez de `global_position`; instanciar sin agregar al árbol.

### T14 — Cuarto limpio y puerta
- **Tipo:** A · **Est.:** 45 min · **Depende de:** T13
- **Objetivo:** contar enemigos vivos con señales y abrir/cerrar la puerta (colisión y sprite).
- **Aceptación:** la puerta empieza cerrada; se abre exactamente cuando muere el último enemigo; el cambio de colisión usa `set_deferred`.
- **Errores comunes:** contar con `get_child_count`; que el contador falle si dos enemigos mueren a la vez.

### T15 — Autoload `GameState` y siguiente cuarto
- **Tipo:** A · **Est.:** 60 min · **Depende de:** T14, T10
- **Objetivo:** un autoload que guarda cuarto actual y vida; al cruzar la puerta se cambia al siguiente cuarto con la vida conservada.
- **Aceptación:** la vida persiste entre cuartos; el jugador aparece en la entrada del siguiente cuarto; el autoload está registrado en Project Settings.
- **Errores comunes:** guardar estado en el jugador, que se destruye con la escena; olvidar reiniciar el autoload al perder.

### T16 — Victoria y reinicio completo
- **Tipo:** A · **Est.:** 30 min · **Depende de:** T15
- **Objetivo:** pantalla de victoria al terminar el tercer cuarto; perder reinicia `GameState`.
- **Aceptación:** tras perder, la partida empieza en el cuarto 1 con vida completa; tras ganar se puede volver al inicio.
- **Errores comunes:** que el estado del autoload sobreviva a un game over.

## M5 — Mejoras

### T17 — `Resource` `Upgrade`
- **Tipo:** A · **Est.:** 45 min · **Depende de:** T15
- **Objetivo:** un script con `class_name Upgrade extends Resource` y `@export` (nombre, descripción, tipo, valor).
- **Aceptación:** se puede crear un `.tres` desde el editor y ver sus campos en el Inspector; tipado completo.
- **Errores comunes:** olvidar `class_name`; usar un `Dictionary` en vez de un recurso tipado.

### D04 — Archivos de mejoras
- **Tipo:** D · **Est.:** — · **Depende de:** T17
- **Objetivo:** 5 o 6 `.tres` (más daño, más vida máxima, más velocidad, ataque más rápido, etc.) usando mi script.
- **Aceptación:** los valores se pueden abrir y editar en el Inspector; no se modifica `upgrade.gd`.
- **Errores comunes:** referenciar mal el script del recurso.

### T18 — Pantalla "elige 1 de 3" con pausa
- **Tipo:** A · **Est.:** 60 min · **Depende de:** D04
- **Objetivo:** al limpiar el cuarto, mostrar 3 mejoras al azar, pausar el juego y reanudar al elegir.
- **Aceptación:** `get_tree().paused` pausa el juego pero la UI sigue funcionando (`process_mode`); no se repiten mejoras en las 3 opciones; al elegir se reanuda.
- **Errores comunes:** que la UI quede pausada con todo lo demás; olvidar reanudar.

### T19 — Aplicar mejoras
- **Tipo:** A · **Est.:** 45 min · **Depende de:** T18
- **Objetivo:** guardar las mejoras elegidas en `GameState` y que el jugador lea sus estadísticas desde ahí.
- **Aceptación:** el efecto se nota al jugar (más daño, más velocidad, etc.); las mejoras persisten entre cuartos y se pierden al reiniciar.
- **Errores comunes:** modificar `@export` del jugador en vez del estado compartido; acumular la misma mejora dos veces.

## M6 — Cierre

### T20 — Segundo enemigo con embestida (recortable)
- **Tipo:** A · **Est.:** 60 min · **Depende de:** T09
- **Objetivo:** un enemigo que se detiene, avisa (parpadeo o squash) y embiste en línea recta.
- **Aceptación:** el aviso da tiempo de reaccionar; reutiliza la máquina de estados de T09; aparece en los cuartos 2 y 3.
- **Errores comunes:** embestir sin aviso; que atraviese paredes.

### T21 — Menú principal y sonido
- **Tipo:** A · **Est.:** 45 min · **Depende de:** T16
- **Objetivo:** menú principal, y sonidos de golpe, daño y muerte; decidir de dónde salen (Kenney *Impact Sounds* o *RPG Audio*, o reutilizar los de `leap-to-the-limit`) y una fuente pixel. Retomar buses de audio.
- **Aceptación:** menú como escena principal; cada sonido suena una sola vez por evento; el volumen está balanceado por bus.
- **Errores comunes:** sonidos cortados por `queue_free()` (ver T21 de Salto al Límite).

### C02 — Balance
- **Tipo:** C · **Est.:** 30 min · **Depende de:** T19
- **Objetivo:** ajustar vida, daño, velocidades y número de enemigos para que el cuarto 1 sea fácil y el 3 exigente.
- **Aceptación:** se puede ganar con y sin mejoras fuertes; ningún cuarto es imposible ni trivial.

### C03 — Revisión final
- **Tipo:** C · **Est.:** 30 min · **Depende de:** todo lo anterior
- **Objetivo:** recorrer la DoD punto por punto.
- **Aceptación:** puntos jugados y confirmados por mí; consola sin errores desde el menú; explicaciones por escrito de los conceptos del último punto.
