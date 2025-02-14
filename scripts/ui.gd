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

@onready var resumeBtn = $Resume
@onready var exitBtn = $Quit

var selected_level = {}  # Diccionario vacío para almacenar el nivel seleccionado
var is_game_paused: bool = false

func _render_buttons():
	resumeBtn.visible = is_game_paused
	exitBtn.visible = is_game_paused

func _ready():
	# Crear botones dinámicamente en base a levels_data
	resumeBtn.connect("pressed", Callable(self, "_resume_game"))
	exitBtn.connect("pressed", Callable(self, "_quit_game"))
	GameState.game_paused.connect(_on_game_paused)
	levels_container.add_theme_constant_override("separation", 20) # Agregar separacion entre botones
	create_level_buttons()
	_render_buttons()

func _on_game_paused(paused):
	is_game_paused = paused
	_render_buttons()

func _resume_game() -> void:
	if GameState:
		GameState.change_state(GameState.HState.RESUME)
	
# Función para crear los botones de niveles
func create_level_buttons():
	# Limpiar los botones existentes
	for button in levels_container.get_children():
		button.queue_free()  # Eliminar los botones previos

	# Crear un botón por cada nivel
	for level in levels_data:
		var button = Button.new()
		button.text = level["name"]  # Asumimos que "name" es el nombre del nivel
		button.connect("pressed",Callable(self,"_play_game").bind(level))
		button.custom_minimum_size = Vector2(300, 58)
		levels_container.add_child(button)

func _quit_game() -> void:
	if is_inside_tree():
		get_tree().quit

func _play_game(level):
	if GameState:
		GameState.change_state(GameState.HState.PLAYING)
