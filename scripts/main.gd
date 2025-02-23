extends Node2D

@export var cantidad_animales := 5  # Número de animales a generar

var animal_escena = preload("res://scenes/Animal.tscn")
var quest: Dictionary = {}

func _ready():
	if QuestSystem:
		QuestSystem.set_active_quest.connect(generate_obstacles)
	
func generate_obstacles(quest):
	var obstacles = quest["obstacles"]
	if obstacles.size() == 0:
		return
		
	for i in range(obstacles.size()):
		add_animals(Utils.coords_tovector2(obstacles[i]["init_position"]), Utils.coords_to_vector2(obstacles[i]["end_position"]))

func add_animals(init_pos: Vector2, end_pos: Vector2):
	var init_position := Vector2(init_pos)
	var target_position := Vector2(end_pos)
	
	for i in range(cantidad_animales):
		
		var animal = animal_escena.instantiate()
		
		animal.position = Vector2(
			randi_range(init_position.x, init_position.x + 30),
			randi_range(init_position.y, init_position.y + 30)
		)
		animal.move_to(target_position)
		$AnimalsContainer.add_child(animal)
