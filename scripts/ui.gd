extends Panel

@export var LevelManager: Node
@onready var levels_container = $VBoxContainer  # El contenedor de los botones
@onready var info_label = $Label2  # El label para mostrar la información del nivel seleccionado
@onready var ui_scene_path = "res://ui.tscn"

@onready var resumeBtn = $Resume
@onready var exitBtn = $Quit
@onready var controlsBtn = $Controls

var selected_level = {}  # Diccionario vacío para almacenar el nivel seleccionado
var is_game_paused: bool = false

var levels_data
var levels_file_path = "res://data/levels.json"


func _render_buttons():
	resumeBtn.visible = is_game_paused
	exitBtn.visible = is_game_paused

func _ready():
	# Crear botones dinámicamente en base a levels_data
	print(" carga ready de ui")
	load_levels()	
	resumeBtn.connect("pressed", Callable(self, "_resume_game"))
	exitBtn.connect("pressed", Callable(self, "_quit_game"))
	controlsBtn.connect("pressed", Callable(self, "_controls_game"))
	GameState.game_paused.connect(_on_game_paused)
	levels_container.add_theme_constant_override("separation", 20) # Agregar separacion entre botones


func load_levels() -> void:
	levels_data = Utils.read_json(levels_file_path, Utils.JsonType.Array)
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
		
func _controls_game() -> void:
	GameState.change_state(GameEnums.HudState.CONTROLS_OPEN)

	
func _play_game(level):
	if GameState:
		GameState.change_state(GameState.HState.PLAYING)
