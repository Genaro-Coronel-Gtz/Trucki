extends Node

@onready var player: CharacterBody2D  = $"../Player" # Referencia al jugador
var levels : Array = []
var levels_file_path = "res://data/levels.json"

# Datos de los niveles y misiones asociadas
var current_level_index = 1  # Índice del nivel actual

func _ready():
	_load_levels_data()

func _load_levels_data():
	levels = Utils.read_json(levels_file_path, Utils.JsonType.Array)
	load_level(current_level_index)  

func load_level(index):
	if index >= levels.size():
		print("No hay más niveles disponibles.")
		return

	var level_data = levels[index]
	# Asigna misiones al QuestSystem
	if QuestSystem:
		QuestSystem.start_new_quests(level_data)

func next_level():
	current_level_index += 1
	if current_level_index < levels.size():
		load_level(current_level_index)
	else:
		print("¡Has completado todos los niveles!")
