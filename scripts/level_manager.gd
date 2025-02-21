extends Node

@onready var player: CharacterBody2D  = $"../Player" # Referencia al jugador

# Datos de los niveles y misiones asociadas
var levels = [
	{
		"id": 1,
		"name": "Reparto - Oficina de correos",
		"start_position": Vector2(500, 200),
		"end_position": Vector2(500, 1000),
		"missions": [
			{"id": "m1", "title": "Encuentra el amuleto", "description": "Busca el amuleto escondido."},
			{"id": "m2", "title": "Derrota al guardián", "description": "Elimina al guardián del bosque."}
		]
	},
	{
		"id": 2,
		"name": "Reparto - Tienda de frutas",
		"missions": [
			{ 
				"id": "m3", 
				"title": "Recolecta gemas", 
				"description": "Encuentra 5 gemas en la cueva.",
				"initial_player_position": Vector2(-33, -273),
				"obstacles": [
					{ "init_position": Vector2(635, -10) , "end_position": Vector2(705, -10) },
					{ "init_position": Vector2(0,0) , "end_position": Vector2(0,0) },
				],
				"start_position": Vector2(-50, 10),
				"end_position": Vector2(650, -200),
			},
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
	# Asigna misiones al QuestSystem
	if QuestSystem:
		QuestSystem.start_new_quests(level_data)

func next_level():
	current_level_index += 1
	if current_level_index < levels.size():
		load_level(current_level_index)
	else:
		print("¡Has completado todos los niveles!")
