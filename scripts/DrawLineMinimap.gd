extends Line2D

@onready var tilemap = $"../HighWayLayerMinimap"
@onready var player = $"../../../../Player"

@export var start_texture : Texture
@export var end_texture : Texture

var path_points = []  # Lista para almacenar los puntos de la ruta

func _ready() -> void:
	width = 3
	default_color = Color(0, 1 ,0)
	await get_tree().process_frame
	#_draw_markers()
	_draw_markers_textures()
	_draw_path_line()

func _draw():
	clear_points()
	if path_points.size() > 1:
		for point in path_points:
			add_point(point)

func _draw_markers_textures():
	# Verifica si las texturas han sido asignadas en el inspector
	if start_texture:
		# Crear y posicionar el marcador inicial con la textura asignada
		var pinicial = TextureRect.new()
		pinicial.texture = start_texture
		pinicial.expand_mode = TextureRect.EXPAND_IGNORE_SIZE  # Mantiene el tamaño original
		pinicial.size = Vector2(16, 16)  # Ajusta según tu textura
		pinicial.position = Vector2(650, -200)
		add_child(pinicial)
	
	if end_texture:
		# Crear y posicionar el marcador final con la textura asignada
		var pfinal = TextureRect.new()
		pfinal.texture = end_texture
		pfinal.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pfinal.size = Vector2(16, 16)
		pfinal.position = Vector2(-50, 0)
		add_child(pfinal)


func _draw_markers():
	var pfinal = ColorRect.new()
	pfinal.color = Color(1, 0, 0)
	pfinal.size = Vector2(16, 16)
	pfinal.position = Vector2(-50, 0)
	add_child(pfinal)
	
	var pinicial = ColorRect.new()
	pinicial.color = Color(0, 1, 0)
	pinicial.size = Vector2(16, 16)
	pinicial.position = Vector2(650, -200)
	add_child(pinicial)

func _draw_path_line():
	var start_pos = Vector2(-50, 0)
	var end_pos = Vector2(650, -200)
	calculate_navigation_path(start_pos, end_pos)
	#queue_redraw()

func calculate_navigation_path(start_pos: Vector2, end_pos: Vector2):
	var navigation_map = tilemap.get_navigation_map()
	if navigation_map == null:
		print("❌ ERROR: No se encontró un mapa de navegación en el TileMap.")
		return
	
	var path = NavigationServer2D.map_get_path(navigation_map, start_pos, end_pos, false)
	
	if path.size() > 1:
		path_points.clear()
		path_points = path
		queue_redraw()  # 🔄 Redibuja después de calcular la ruta
	else:
		print("⚠️ No se encontró una ruta válida.")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		_draw_path_line()
		# _draw_markers()
