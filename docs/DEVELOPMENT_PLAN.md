# Plan de desarrollo — Dungeon Survivor

## Concepto
Un dungeon top-down de 3 cuartos. El héroe entra a un cuarto, las puertas se cierran y aparecen enemigos. Los mata con la espada y la puerta se abre. Elige 1 de 3 mejoras y pasa al siguiente cuarto. Si su vida llega a 0, pierde y la partida empieza desde cero. Si limpia el último cuarto, gana.

- Motor: Godot 4.7, GL Compatibility, GDScript tipado.
- Arte: Kenney Tiny Dungeon (CC0) en `assets/`. Sonido y fuente se resuelven en T21.
- Tareas detalladas: `docs/TASK_BACKLOG.md`. Seguimiento: `docs/LEARNING_PROGRESS.md`.

## Core gameplay loop
Entrar → pelear (atacar, esquivar, recibir daño) → limpiar el cuarto → elegir mejora → siguiente cuarto.

## Alcance del MVP
- Movimiento top-down en 8 direcciones, con dirección de mirada y animación procedural (los sprites tienen un solo frame).
- Ataque con espada: hitbox activa solo durante el golpe, con cooldown.
- Vida del jugador con i-frames y parpadeo. HUD de vida.
- Enemigos con vida, knockback y flash al ser golpeados. Persiguen al jugador con una máquina de estados simple.
- Un enemigo base y un segundo tipo con embestida (este último se puede recortar).
- 3 cuartos hechos a mano, uno por pantalla (20x11 tiles, cámara fija). Los enemigos aparecen en `Marker2D`; la puerta se cierra y se abre al limpiar.
- Autoload `GameState`: cuarto actual, vida y mejoras. Se reinicia al perder.
- Mejoras como `Resource` personalizado (`.tres`) y pantalla "elige 1 de 3" con pausa.
- Menú principal, game over, victoria y sonido básico.

## Fuera de alcance
Generación procedural, minimapa, inventario o varias armas, jefes, guardado persistente, `NavigationAgent2D` y pathfinding (los cuartos tendrán pocos obstáculos), soporte de mando, shaders y partículas complejas.

## Ideas post-MVP
Jefe final, dash con i-frames, proyectiles como mejora, cuartos aleatorios, `NavigationAgent2D`, coyote-style buffer de ataque.

## Objetivos de aprendizaje
| ★ Nuevo | ♻ Repaso |
|---|---|
| Patrón hitbox/hurtbox con `area_entered` | `Area2D`, layers y masks, grupos |
| Ataque con `AnimationPlayer` que controla una colisión y un pivote `Node2D` rotado | `AnimationPlayer` |
| Animación procedural para personajes de un frame (rebote, squash, flash con `modulate`) | `Tween`, `flip_h` |
| Cooldown e i-frames con `Timer` | `Timer`, `await` |
| Knockback con impulso y `move_toward` | `velocity`, `move_and_slide()` |
| IA de persecución con `direction_to` y máquina de estados (`enum` + `match`) | Patrulla, `flip_h` |
| Instanciar escenas en ejecución (`preload`, `instantiate()`, `add_child`) | Instanciar en el editor |
| Contar enemigos vivos para limpiar el cuarto y abrir la puerta | Señales, "call down, signal up" |
| **Autoload** para el estado entre escenas y su reinicio | `change_scene_to_file`, `reload_current_scene` |
| `Resource` personalizado con `class_name` y archivos `.tres` | `@export` |
| Pausa: `get_tree().paused` y `process_mode` | `Control`, contenedores, botones |
| Y-sort; barra o corazones de vida | `CanvasLayer`, `LabelSettings` |

Pendientes de proyectos anteriores que se retoman aquí: autoload, `move_toward`, `class_name` para tipar referencias, buses de audio, y por qué `set_deferred` en cambios de física dentro de señales.

## Fases
| Fase | Objetivo | Tareas |
|---|---|---|
| **M0 Preparación** | Proyecto listo para pixel art, assets identificados, `TileSet` y cuarto de pruebas | T01, D01, T02, D02 |
| **M1 Jugador** | Un héroe que se mueve y mira hacia donde va | T03, T04 |
| **M2 Combate** | Atacar y golpear a un enemigo | C01, T05–T08 |
| **M3 Enemigo y vida** | El enemigo persigue y hace daño; el jugador puede morir | T09–T12 |
| **M4 Cuartos** | Cuartos con puertas, enemigos instanciados, estado entre cuartos, victoria | D03, T13–T16 |
| **M5 Mejoras** | Elegir 1 de 3 y aplicar su efecto | T17, D04, T18, T19 |
| **M6 Cierre** | Segundo enemigo, menú, sonido, balance y revisión | T20, T21, C02, C03 |

## Dependencias
```
M0 → M1 → C01 → M2 → M3 → M4 → M5 → M6
					  D03 se puede hacer en paralelo desde M1
```
- Casi todo depende del jugador (M1).
- El combate (M2) necesita el jugador y un enemigo estático para probar la espada.
- El estado entre cuartos (T15) necesita vida del jugador (T10) y cuartos armados (D03).
- Las mejoras (M5) necesitan el autoload (T15) y la pantalla de pausa.

## Quién hace qué
| Tipo | Tareas |
|---|---|
| **A: Aprendizaje (tú)** | T01–T21 |
| **D: Contenido delegado (yo, con tu autorización cada vez)** | D01 mapa de assets, D02 cuarto de pruebas, D03 layout de cuartos, D04 archivos `.tres` de mejoras |
| **C: Compartido** | C01 flujo del daño, C02 balance, C03 revisión final |

Las tareas D solo identifican assets, pintan tiles, colocan instancias o escriben datos. No tocan scripts de gameplay, Input Map, física, señales ni ajustes del proyecto.

## Calendario estimado (5–8 h por semana)
| Semana | Fases |
|---|---|
| 1 | M0, M1 |
| 2 | M2 |
| 3 | M3 |
| 4 | M4 |
| 5 | M5, M6 |

Unas 16 h de tareas; con depuración y revisión, entre 20 y 25 h. Si hay que recortar, primero sale T20, después la música, y al final se baja a 2 cuartos.

## Definición de terminado (DoD)
- [ ] El jugador se mueve, ataca con cooldown y la espada pega hacia donde mira.
- [ ] Los enemigos persiguen, reciben daño con knockback y mueren.
- [ ] El jugador recibe daño con i-frames, el HUD lo muestra y a 0 de vida hay game over.
- [ ] Cada cuarto cierra la puerta, hace aparecer enemigos y la abre al limpiarse.
- [ ] Al limpiar un cuarto se elige 1 de 3 mejoras y su efecto se nota.
- [ ] La vida y las mejoras persisten entre cuartos y se reinician al perder.
- [ ] Hay victoria al terminar el tercer cuarto, menú y sonido.
- [ ] La consola no muestra errores al jugar desde el menú. El código está tipado.
- [ ] Puedo explicar con mis palabras: hitbox vs. hurtbox, para qué sirve un autoload y por qué hay que reiniciarlo, y qué hace `process_mode` durante la pausa.
