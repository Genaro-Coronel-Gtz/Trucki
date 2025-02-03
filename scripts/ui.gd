extends Panel

@export var levels_data = [
	{ "name": "Bosque Encantado", "start_position": Vector2(100, 200), "end_position": Vector2(500, 200) },
	{ "name": "Cueva Oscura", "start_position": Vector2(50, 300), "end_position": Vector2(600, 300) },
	{ "name": "Montañas Nevadas", "start_position": Vector2(200, 500), "end_position": Vector2(700, 500) }
]
@export var LevelManager: Node
@onready var levels_container = $VBoxContainer  # El contenedor de los botones
@onready var info_label = $Label2  # El label para mostrar la información del nivel seleccionado
@onready var ui_scene_path = "res://ui.tscn"


var selected_level = {}  # Diccionario vacío para almacenar el nivel seleccionado

func _ready():
	# Crear botones dinámicamente en base a levels_data
	create_level_buttons()
	
# Función para crear los botones de niveles
func create_level_buttons():
	# Limpiar los botones existentes
	print(" levels container ", )
	for button in levels_container.get_children():
		button.queue_free()  # Eliminar los botones previos

	# Crear un botón por cada nivel
	for level in levels_data:
		print(" Level ", level)
		var button = Button.new()
		button.text = level["name"]  # Asumimos que "name" es el nombre del nivel
		button.connect("pressed",Callable(self,"_start_level").bind(level))
		levels_container.add_child(button)

func _start_level(level):
	print(" iniciar nivel ", level)
	selected_level = level
	info_label.text = "Nivel seleccinado: " + selected_level["name"]
	print("Nivel seleccionado:", selected_level["name"])
	var ui_scene = preload("res://high_way_tmap.tscn")
	if ui_scene:
		get_tree().change_scene_to_packed(ui_scene)
