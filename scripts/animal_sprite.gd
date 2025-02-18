extends CharacterBody2D

@onready var anim_sprite = $AnimatedSprite2D  # Referencia al nodo de animación

@export var speed := 50.0  # Velocidad del animal
@export var animal_type: String = "Cerdo"

var target_point: Vector2
var direction: Vector2

func _ready():
	add_to_group("Animals")
	elegir_nuevo_destino()

func _physics_process(delta):
	direction = (target_point - position).normalized()
	velocity = direction * speed
	
	# Cambiar animación según el movimiento
	if velocity.length() > 0:
		anim_sprite.play("walk")  # Animación de caminar
	else:
		anim_sprite.play("idle")  # Animación de estar quieto
	
	# Voltear el sprite según la dirección
	if velocity.x < 0:
		anim_sprite.flip_h = true
	elif velocity.x > 0:
		anim_sprite.flip_h = false
	
	#move_and_slide()

	#if position.distance_to(target_point) < 5:
		#elegir_nuevo_destino()

func elegir_nuevo_destino():
	var random_x = randi_range(100, 800)  # Ajusta según el tamaño del mapa
	var random_y = randi_range(100, 600)
	target_point = Vector2(random_x, random_y)

	# Ajustar dirección de la animación
	if target_point.x > position.x:
		anim_sprite.flip_h = false  # Mirar a la derecha
	else:
		anim_sprite.flip_h = true   # Mirar a la izquierda
