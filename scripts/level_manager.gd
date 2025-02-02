extends Node

@export var quest_system: Node  # Referencia al sistema de misiones
@export var player: CharacterBody2D  # Referencia al jugador

# Datos de los niveles y misiones asociadas
var levels = [
	{
		"id": 1,
		"name": "Bosque Encantado",
		"start_position": Vector2(100, 200),
		"end_position": Vector2(200, 200),
		"missions": [
			{"id": "m1", "title": "Encuentra el amuleto", "description": "Busca el amuleto escondido."},
			{"id": "m2", "title": "Derrota al guardián", "description": "Elimina al guardián del bosque."}
		]
	},
	{
		"id": 2,
		"name": "Cueva Oscura",
		"start_position": Vector2(500, 100),
		"end_position": Vector2(100, 300),
		"missions": [
			{"id": "m3", "title": "Recolecta gemas", "description": "Encuentra 5 gemas en la cueva."},
			{"id": "m4", "title": "Escapa antes del derrumbe", "description": "Llega a la salida antes de que se derrumbe."}
		]
	}
]

var current_level_index = 1  # Índice del nivel actual

func _ready():
	load_level(current_level_index)  # Carga el primer nivel al iniciar el juego

func load_level(index):
	if index >= levels.size():
		print("No hay más niveles disponibles.")
		return

	var level_data = levels[index]
	# Mueve al jugador al punto de inicio
	player.position = level_data["start_position"]

	# Asigna misiones al QuestSystem
	if quest_system:
		quest_system.start_new_quests(level_data)

func next_level():
	current_level_index += 1
	if current_level_index < levels.size():
		load_level(current_level_index)
	else:
		print("¡Has completado todos los niveles!")
