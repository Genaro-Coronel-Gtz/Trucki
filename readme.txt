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
	alguna logica revisar primero hud.gd y ui.gd)
* Implementar el state machine para las animaciones, etc..

* Implementar un tema para la interfaz (Desde el gestor de temas)
* Agregar sonidos al juego (animales, carro y musica de fondo ) en 8 bits, talvez con sonic pi

* Implementar varios tipos de animales (Ver si se crearan en escenas separadas, etc)
* Cambiar el player a una escena

* Agregar los tiles para pintar bien los cruces de calles en el mapa
* Agregar mas ornamentos para el juego
* Agregar letreros en el mapa
* Agregar edificios al mapa

* Crear bien el mapa completo del mundo
* Crear bien la interfaz grafica para el juego (HUD)

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
