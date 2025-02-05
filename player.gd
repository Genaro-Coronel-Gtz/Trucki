extends CharacterBody2D

@onready var minimap_player = $"../CanvasLayer/SubViewportContainer/SubViewport/Sprite2D"
@export var quest_system: Node  # Referencia al sistema de misiones
@onready var truck_animated = $AnimatedSprite2D
@onready var truck_box_anim = $TruckBox

@onready var area2d = $Area2D 
@onready var current_animation: AnimatedSprite2D = null

var speed = 100
var health = 100

var counter = 0
var minimap_camera
var active_quest = null
const POSITION_CAMERA_OFFSET_X = 50
const INITIAL_POSITION: Vector2 = Vector2(100, 100)

func assign_quest(quest_id):
	if quest_system == null:
		print("⚠️ QuestSystem no está asignado en el Player")
		return
	
	# Iterar sobre las misiones activas
	for quest in quest_system.active_quests:
		if quest["id"] == quest_id:
			active_quest = quest
			print("📜 Nueva misión asignada:", active_quest["title"])
			return  # Terminar la función después de asignar la misión
		 
	# Si no encontramos la misión
	print("⚠️ Misión no encontrada:", quest_id)


# 🚀 Revisar si el jugador está en la zona de inicio
func check_mission_start():
	if active_quest == null:
		return

	var player_pos = position
	var start_pos = active_quest["start_pos"]

	if player_pos.distance_to(start_pos) < 20:  # Ajusta el radio de detección
		# print("🎯 Misión iniciada:", active_quest["title"])
		active_quest["state"] = "in_progress"
		_active_animation("box")

# ✅ Revisar si el jugador llegó a la zona de fin
func check_mission_complete():
	if active_quest == null:
		return

	var player_pos = position
	var end_pos = active_quest["end_pos"]

	if player_pos.distance_to(end_pos) < 20:
		print("🏁 Misión completada:", active_quest["title"])
		quest_system.complete_quest(active_quest["id"])
		active_quest = null  # Liberar misión activa
		_active_animation("single")

func _active_animation(animation):
	if animation == "single":
		truck_box_anim.hide()
		truck_animated.show()
		current_animation = truck_animated
	else:
		truck_box_anim.show()
		truck_animated.hide()
		current_animation = truck_box_anim

func _ready():
	print("instancia de player", self)
	area2d.body_entered.connect(_on_body_entered)
	_active_animation("single")
	
	call_deferred("set_position", INITIAL_POSITION)
	
	await get_tree().process_frame
	
	minimap_camera = get_node_or_null("../CanvasLayer/SubViewportContainer/SubViewport/Camera2D")
	if minimap_camera == null:
		print("⚠️ ERROR: No se encontró la cámara del minimapa. Verifica la estructura de nodos.")
	assign_quest("m3")
	
func _on_body_entered(body):
	if body.is_in_group("Animals"):
		take_damage(5)
		print(" Colision detectada con animal", body.animal_type)

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		print(" El jugador ha muerto")
		GameState.change_state(GameState.State.MAIN_MENU)

func updateStats():
	var stats: Dictionary = {
		"health": health,
		"speed": speed,
		"position": global_position
	}
	GameData.set_stats(stats)

# En el _process del QuestSystem
func _process(delta):
	check_mission_start()
	check_mission_complete()

func _physics_process(delta):
	# Entrada del jugador
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_show"):
		GameState.change_state(GameState.State.MAIN_MENU)
	if Input.is_action_pressed("ui_show_main_menu"):
		GameState.change_state(GameState.State.PAUSED)
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
		counter += 1 
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
		counter += 1 
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		counter += 1 
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		counter += 1 
		
	if counter == 150:
		speed = 200

	# Movimiento del jugador
	direction = direction.normalized()
	if direction.is_zero_approx():
		speed = 100
		counter = 0
	
	velocity = direction * speed
	
	if velocity.length() != 0:
		current_animation.play("drive")
	else:
		current_animation.play("idle")
	
	move_and_slide()

	# Rotación basada en el movimiento
	if direction != Vector2.ZERO:
		rotation = direction.angle()  # Gira el sprite según el ángulo del movimiento
		
	if minimap_camera:
		# minimap_camera.position = position
		minimap_camera.position.x = position.x + POSITION_CAMERA_OFFSET_X
		minimap_camera.position.y = position.y
		# Actualiza la posición del Sprite2D en el minimapa
	if minimap_player:
		minimap_player.position = position
		minimap_player.rotation = direction.angle()
	updateStats()
