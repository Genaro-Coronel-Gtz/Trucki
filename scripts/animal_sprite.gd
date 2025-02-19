extends CharacterBody2D

@onready var anim_sprite = $AnimatedSprite2D  # Referencia al nodo de animación

@export var speed := 2.5  # Velocidad del animal
@export var animal_type: String = "Cerdo"

var target_position: Vector2

func _damage():
	queue_free()

func _ready():
	add_to_group("Animals")
	
func _animation_direction():
	if velocity.length() > 0:
		anim_sprite.play("walk")  # Animación de caminar
	else:
		anim_sprite.play("idle")  # Animación de estar quieto
	
	# Voltear el sprite según la dirección
	if velocity.x > 0:
		anim_sprite.flip_h = true
	elif velocity.x < 0:
		anim_sprite.flip_h = false

func _process(delta):
	if position.distance_to(target_position) > 5:  # Si aún no ha llegado
		var direction = (target_position - position).normalized()
		velocity = direction * speed
		_animation_direction()
		move_and_slide() 
	else:
		queue_free()
		velocity = Vector2.ZERO  # Detener al llegar

func move_to(new_target: Vector2):
	target_position = new_target
