extends Node

signal dialogue_started(text, options)
signal dialogue_ended

signal start_mission

var dialogues = {}  # Almacenará los diálogos cargados
var current_dialogue = {}  # Diálogo actual

func _ready():
	load_dialogues()

# Cargar diálogos desde el archivo JSON
func load_dialogues():
	var file = FileAccess.open("res://data/dialogues.json", FileAccess.READ)
	if file:
		dialogues = JSON.parse_string(file.get_as_text())
		file.close()

# Iniciar un diálogo por su ID
func start_dialogue(dialogue_id):
	if dialogues.has(dialogue_id):
		current_dialogue = dialogues[dialogue_id]
		print(" current dialogue ", current_dialogue)
		dialogue_started.emit(current_dialogue["text"], current_dialogue.get("options", []))

# Elegir una opción del diálogo
func choose_option(option):
	if option.has("action"):
		execute_action(option["action"])  # Ejecutar la acción asignada
	
	if option["next"] != "":
		start_dialogue(option["next"])  # Ir al siguiente diálogo
	else:
		dialogue_ended.emit()  # Terminar el diálogo

# Ejecutar una acción del JSON
func execute_action(action):
	match action:
		"start_game":
			print("start mission emit")
			start_mission.emit()
		"cancel":
			print("El jugador no quiere empezar.")
		"start_forest":
			print("Iniciando en el Bosque Encantado.")
