extends CanvasLayer
# Called when the node enters the scene tree for the first time.
@onready var viewportContainer = $SubViewportContainer
@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var border = $SubViewportContainer/BorderLine
@onready var camera = $SubViewportContainer/SubViewport/Camera2D

func _ready() -> void:
	camera.zoom = Vector2(0.8, 0.8)
	var screen_size = get_viewport().get_visible_rect().size
	viewportContainer.position = Vector2(screen_size.x - viewportContainer.size.x, screen_size.y - viewportContainer.size.y)
	_draw_border()

func _draw_border():
	var sub_viewport_size = sub_viewport.get_size()
	# Limpiar puntos anteriores
	border.clear_points()
	# Convertir las coordenadas al sistema de coordenadas locales del SubViewport
	var top_left = Vector2(0, 0)  # Esquina superior izquierdas
	var top_right = Vector2(sub_viewport_size.x - 90, 0)  # Esquina superior derecha
	var bottom_left = Vector2(0, sub_viewport_size.y)  # Esquina inferior izquierda
	var bottom_right = Vector2(sub_viewport_size.x - 90, sub_viewport_size.y)  # Esquina inferior derecha

	# Añadir puntos para el borde en el Line2D (en coordenadas locales del SubViewport)
	border.add_point(top_left)        # Esquina superior izquierda
	border.add_point(top_right)       # Esquina superior derecha
	border.add_point(bottom_right)    # Esquina inferior derecha
	border.add_point(bottom_left)     # Esquina inferior izquierda
	border.add_point(top_left)        # Volver a la esquina inicial
	# Configuración de la línea
	border.width = 3
	border.default_color = Color(0, 1, 0)  # Color rojo para el borde

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_show_map"):
		if viewportContainer.visible:
			viewportContainer.hide()
		else:
			viewportContainer.show()
