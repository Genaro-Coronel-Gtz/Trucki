extends CharacterBody2D

@onready var minimap_player = $"../MiniMap/SubViewportContainer/SubViewport/Sprite2D"
@onready var truck_animated = $AnimatedSprite2D
@onready var truck_box_anim = $TruckBox

@onready var area2d = $Area2D 
@onready var animation_state_machine: Node = $AnimationStateMachine
@onready var minimap_camera = $"../MiniMap/SubViewportContainer/SubViewport/Camera2D"


var speed = 100
var health = 100

var counter = 0

var active_quest = null
const POSITION_CAMERA_OFFSET_X = 50
const INITIAL_POSITION: Vector2 = Vector2(100, 100)

const State = preload("res://scripts/game_enums.gd").State

func assign_quest(quest_id):
	if QuestSystem == null:
		print("QuestSystem no está asignado en el Player")
		return
	
	# Iterar sobre las misiones activas
	for quest in QuestSystem.active_quests:
		if quest["id"] == quest_id:
			active_quest = quest
			QuestSystem._set_current_quest(quest)
			position = active_quest["initial_player_position"]
			# print(" quest ", quest)
			print("Nueva mision asignada:", active_quest["title"])
			return  # Terminar la función después de asignar la misión
		 
	# Si no encontramos la misión
	print("Mision no encontrada:", quest_id)

func _start_mission():
	print("Mision iniciada:", active_quest["title"])
	active_quest["state"] = "in_progress"
	animation_state_machine.change_state(State.BOX)

# 🚀 Revisar si el jugador está en la zona de inicio
func check_mission_start():
	if active_quest == null:
		return

	var player_pos = position
	var start_pos = active_quest["start_position"]

	# Ajusta el radio de detección y si no ha iniciado la mision
	if player_pos.distance_to(start_pos) < 20 and active_quest["state"] =="not_started":
		print(" Dialog manager must be opened")
		DialogueManager.start_dialogue("start_game")
		#DialogueManager.start_dialogue("test_dialogue")

# Revisar si el jugador llegó a la zona de fin
func check_mission_complete():
	if active_quest == null:
		return

	var player_pos = position
	var end_pos = active_quest["end_position"]

	if player_pos.distance_to(end_pos) < 20:
		print("-- Misión completada:", active_quest["title"])
		QuestSystem.complete_quest(active_quest["id"])
		active_quest = null  # Liberar misión activa
		animation_state_machine.change_state(State.SINGLE)

func _ready():
	DialogueManager.start_mission.connect(_start_mission)
	area2d.body_entered.connect(_on_body_entered)
	animation_state_machine.change_state(State.SINGLE)
	
	#call_deferred("set_position", INITIAL_POSITION)
	
	await get_tree().process_frame
	assign_quest("m3")
	
	if minimap_camera == null:
		print("ERROR: No se encontró la cámara del minimapa. Verifica la estructura de nodos.")
	
	
func _on_body_entered(animalInstance):
	if animalInstance.is_in_group("Animals"):
		animalInstance._damage()
		take_damage(5)


func take_damage(damage: int):
	health -= damage
	if health <= 0:
		print(" El jugador ha muerto")
		GameState.change_state(GameState.HState.MAIN_MENU)

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
	if Input.is_action_pressed("ui_cancel"):
		GameState.change_state(GameState.HState.PAUSED) #Menu pausa
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
		print(" emiting ")
	

	# Movimiento del jugador
	direction = direction.normalized()
	if direction.is_zero_approx():
		
		speed = 100
		counter = 0
	
	velocity = direction * speed
	
	if velocity.length() != 0:
		animation_state_machine.change_state(State.DRIVE)
	else:
		animation_state_machine.change_state(State.IDLE)
	
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
