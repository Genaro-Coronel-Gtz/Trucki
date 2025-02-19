extends Node2D

@export var cantidad_animales := 5  # Número de animales a generar

var animal_escena = preload("res://scenes/Animal.tscn")
var quest: Dictionary = {}

func _ready():
	if QuestSystem:
		QuestSystem.set_active_quest.connect(generar_animalitos)
	#generar_animalitos()

func generar_animalitos(quest):
	#print(" quest ", quest["obstacles"][0]["end_position"])
	
	var target_position := Vector2(quest["obstacles"][0]["end_position"])
	var init_position := Vector2(quest["obstacles"][0]["init_position"])
	
	for i in range(cantidad_animales):
		
		var animal = animal_escena.instantiate()
		
		animal.position = Vector2(
			randi_range(init_position.x, init_position.x + 30),
			randi_range(init_position.y, init_position.y + 30)
		)
			#animal.position = quest["obstacles"][0]["initial_position"]
		animal.move_to(target_position)
		$AnimalsContainer.add_child(animal)
