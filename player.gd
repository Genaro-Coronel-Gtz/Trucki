extends CharacterBody2D

# Velocidad del jugador
var speed = 100
var counter = 0
var minimap_camera
var active_quest = null
const POSITION_CAMERA_OFFSET_X = 50

@onready var minimap_player = $"../CanvasLayer/SubViewportContainer/SubViewport/Sprite2D"
@onready var speed_label = $"../HUD/SpeedLabel"
@export var quest_system: Node  # Referencia al sistema de misiones
@onready var ui_scene_path = "res://ui.tscn"

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
		
func _ready():
	await get_tree().process_frame
	minimap_camera = get_node_or_null("../CanvasLayer/SubViewportContainer/SubViewport/Camera2D")
	if minimap_camera == null:
		print("⚠️ ERROR: No se encontró la cámara del minimapa. Verifica la estructura de nodos.")
	assign_quest("m3")

func updateStats():
	if speed_label:
		speed_label.text = "Velocidad: " + str(speed)

# En el _process del QuestSystem
func _process(delta):
	check_mission_start()
	check_mission_complete()

func loadui():
	var ui_scene = load(ui_scene_path)
	if ui_scene_path:
		get_tree().change_scene_to_packed(ui_scene)
		
func _physics_process(delta):
	# Entrada del jugador
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_show"):
		loadui()
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
