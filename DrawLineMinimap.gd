extends Line2D

@onready var tilemap = $"../HighWayLayerMinimap"
@onready var player = $"../../../../CharacterBody2D"

func _process(delta):
	#var end_pos = Vector2(650, -200)  # 📍 La posición final es donde hace clic el jugador
	#draw_navigation_path(player.position, end_pos)
	pass

func _draw_markers():
	var pfinal = ColorRect.new()
	pfinal.color = Color(1, 0 ,0)
	pfinal.size = Vector2(16, 16)  # Ajusta el tamaño según el grid del TileMap
	pfinal.position = Vector2(-50, 0)
	add_child(pfinal)
	
	var pinicial = ColorRect.new()
	pinicial.color = Color(0, 1 ,0)
	pinicial.size = Vector2(16, 16)  # Ajusta el tamaño según el grid del TileMap
	pinicial.position = Vector2(650, -200)
	add_child(pinicial)

func draw_path_line():
		var start_pos = Vector2(-50, 0)  # 🏁 Posición inicial (Ejemplo, cámbiala)
		var end_pos = Vector2(650, -200)  # 📍 La posición final es donde hace clic el jugador
		draw_navigation_path(start_pos, end_pos)  # 🔥 Calcula y dibuja la ruta

# 🛣️ Dibuja una línea entre dos puntos evitando colisiones de TileMap
func draw_navigation_path(start_pos: Vector2, end_pos: Vector2):
	var navigation_map = tilemap.get_navigation_map()  # 📌 Obtiene el mapa de navegación
	# ⚡ Calcula la mejor ruta evitando colisiones
	var path = NavigationServer2D.map_get_path(navigation_map, start_pos, end_pos, false)

	if path.size() > 1:
		clear_points()  # 🔄 Limpia la línea anterior
		default_color = Color(0, 1 , 0)
		antialiased = true
		width = 4
		for point in path:
			add_point(point)  # 🖌️ Agrega los puntos de la ruta al Line2D

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		draw_path_line()
		_draw_markers()
