Juego realizado con Godot 4.3

TODO:
	
* VERIFICAR POR QUE SE DUPLICAN LA ESCNEA DONDE ESTA EL PLAYER
 DEBE SER ALGO DE COMO SE CARGA EN EL QuestSystem o el LevelManager,
VERIFICAR TAMBIEN EN LOS NUEVOS CAMBIOS DEL HUD Y EL GAME STATE -> ok
Listo, lo que pasaba que se agregaba la escena del juego con add_child
y no con :
				if is_inside_tree():
				get_tree().change_scene_to_packed(game_scene)

* Falta agregar el SaveManager con archivos .json (Guardar tambien la ubicacion del player, y los niveles que se han pasados) ->ok 

* Verificar por que se sigue mostrando el minimapa cuando se muestra el menu pause, pero cuando
	el main menu se muestra si se oculta correctamente el minimapa. (puede ser cuestion de capas ,zindex, o de
	alguna logica revisar primero hud.gd y ui.gd) -> ok
	
* Implementar el state machine para las animaciones, etc.. -> ok
* Implementar enums globales -> ok


------------------------------------------------------------------------------------
Tratar de avanzar el 11 de Frebrero de 2025

* Cambiar el enum de GameState a global_state e importarlo en GameState -> ok

* Implementar un tema para la interfaz (Desde el gestor de temas) -> ok
* Agregar fuente personalizada -> ok
* Crear bien la interfaz grafica para el juego (HUD) -> Ok

-------------------------------------------------------------------------------------------
* Crear sistema de dialogos Generico (Ver si se puede exportar como plugin)
* Crear dialogos del juego 


* Implementar logica para guardar en menu pausa antes de salir a menu principal:
	En menu pausa, si el usuario da click en el boton menu principal
	-> Mostrar un dialogo que le diga que debe guardar primero el avance
	-> No acepta:
		no se le dejara avanzar al menu principal (no hacer nada, solo cerrar dialogo)
	-> Si acepta:
		Guardar el estado del juego, nivel, recompenzas, etc... y pasar a menu principal
----------------------------------------------------------------------------------------

* Verificar si la escena high_way_tmap se puede cargar directamente (arrastrando ) 
dentro de la misma escena que HUD, Como se hizo con Dialogue UI, y si se puede
como seria para poder mter tambien el player en una escena, ver si no habira problemas con que
una escena este dentro de otra escena que esta dentro de otra escena.

----------------------------------------------------------------------------------------

* Agregar sonidos al juego (animales, carro y musica de fondo ) en 8 bits, talvez con sonic pi
* Implementar varios tipos de animales (Ver si se crearan en escenas separadas, etc)
* Cambiar el player a una escena

-----------------------------------------------------------------------------------------
Crear sistema de mapeo de entradas (teclado, joystick, etc) 
para cargar, guardar y editar configuraciones. 
Se guardara todo en un archivo .cfg 

---------------------------------------------------------------------------------------

Agregar objetos para recojer y sean recompenzas 


----------------------------------------------------------------------------------------

Fix de sistema de niveles y misiones (Ver si podemos cargar los niveles y misiones
base desde un archivo .json , pero los avances de misiones, status del jugador, etc. 
iran en un archivo .cfg )


---------------------------------------------------------------------------------------


* Agregar los tiles para pintar bien los cruces de calles en el mapa
* Agregar mas ornamentos para el juego
* Agregar letreros en el mapa
* Agregar edificios al mapa

* Crear bien el mapa completo del mundo


* Fix por que no se pinta la ruta en el minimapa al iniciarlo.
* Fix de movimientos de animales
* Fix del trazado de ruta en minimapa (La linea aparece torcida cerca de los puntos)
* Fix de detalles visuales, limites de camara , etc..

* Crear una estructura de ficheros y directorios (Arquitectura, buscar alguna arquitectura correcta)
* Renombrar y reestructurar Nodos a nombres correctos y propios para facil legibilidad del codigo.
* Al final se refactorizara el codigo

Nodos:

Para los nodos, se podria crear un nodo padre para los mapas, que se llame Maps o algo asi
y tenga GrassLayer, PlaceLayer,HighWayLayer, investigar si se pueden agrugar en un nodo sin que cambie mucho 
la logica y lo que ya se tiene

Para los nodos LevelManager, QuestSystem, PathLine, AnimalsContainer pueden ir
en un nodo (unicamente para agruparlos) que se llame algo como GameControl

================================
Eliminar este comenario:
	Avance en la funcionalidd de los animales, que crucen la calle segun initial_position y end_position
	que vienen desde level_manager y quest_system
	Se corrigieron algunos datos en level_manager y quest_system
	
	* Scripts que pueden quedar en autolaod ahora: GameSate, GameData y QuestSystem
	  Para el InputManager y el DialogueManager, igual hace falta verificar como 
	  podrian llamarse, sin que sean singleton (osea autoload, pero solo para inputmanager y dialoguemanager)

Verificar el siguiente error que sale en consola:
	
	E 0:01:01:0717   player.gd:150 @ _physics_process(): Parameter "body->get_space()" is null.
  <C++ Fuente>   servers/physics_2d/godot_physics_server_2d.cpp:997 @ body_test_motion()
  <Rastreo de Pila>player.gd:150 @ _physics_process()
Creo que sucede cuando ejecuta el move_and_slide del player
pero como ya no esta en la escena, da ese problema ver como se puede solucionar

Igual hay que agregar una señal para pausar el juego, osea desde el GameState, emitir una señal
para que se pause la escena (es mas para que no sea visible) o al menos ese script 
