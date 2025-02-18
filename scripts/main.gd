extends Node2D

@export var cantidad_animales := 5  # Número de animales a generar
@export var area_spawn_min := Vector2(650, -8)  # Límite inferior del spawn
@export var area_spawn_max := Vector2(700, 37)  # Límite superior del spawn

var animal_escena = preload("res://Animal.tscn")

func _ready():
	# print(" carga ready de main")
	generar_animalitos()


func generar_animalitos():
	for i in range(cantidad_animales):
		var animal = animal_escena.instantiate()
		animal.position = Vector2(
			randi_range(area_spawn_min.x, area_spawn_max.x),
			randi_range(area_spawn_min.y, area_spawn_max.y)
		)
		$AnimalsContainer.add_child(animal)
