extends Node

signal quest_updated(quest_id: String, new_state: String)
signal all_quests_completed
signal set_active_quest(quest)

var start_markers = []  # Lista para marcar zonas de inicio
var end_markers = []  # Lista para marcar zonas de fin

func _ready():
	print("QuestSystem listo", self)

# Iniciar nuevas misiones con zonas marcadas en el mapa
# Función para comenzar nuevas misiones
var active_quests = []  # Lista de misiones activas
var current_quest

func _set_current_quest(quest):
	current_quest = quest
	set_active_quest.emit(quest)

# Función para comenzar nuevas misiones
func start_new_quests(level):
	#print(" Start new quests ", level)
	active_quests.clear()  # Limpiar misiones previas
	var missions = level["missions"]
	for mission_data in missions:
		# Asegúrate de que 'mission_data' es un Dictionary
		if mission_data.has("obstacles") and mission_data.has("initial_player_position") and mission_data.has("id") and mission_data.has("title") and mission_data.has("description") and mission_data.has("start_position") and mission_data.has("end_position"):
			
			var mission = {
				"id": mission_data["id"],
				"title": mission_data["title"],
				"description": mission_data["description"],
				"state": "not_started",
				"start_position": Utils.coords_to_vector2(mission_data["start_position"]),  # Esto podría venir del nivel si lo necesitas
				"end_position": Utils.coords_to_vector2(mission_data["end_position"]),  # Esto también podría ser asignado desde el nivel
				"initial_player_position": Utils.coords_to_vector2(mission_data["initial_player_position"]),
				"obstacles": mission_data["obstacles"]
			}
			
			# Llamar a mark_zone para marcar las zonas
			mark_zone(mission["start_position"], Color(1, 0.5, 0.7, 0.5))  # Zona de inicio (rosado)
			mark_zone(mission["end_position"], Color(0, 1, 0, 0.5))  # Zona de fin (verde)
			active_quests.append(mission)
		else:
			print("Error: La misión no tiene la estructura correcta:", mission_data["title"])
	# print("Misiones cargadas: ", active_quests)
	print("Misiones cargadas")
	
# 🏁 Completar misión
func complete_quest(mission_id):
	#if mission_id in active_quests:
	#active_quests[mission_id]["state"] = "completed"
	#print("active_quests", active_quests)
	#print(" Mision completada:", active_quests[mission_id]["title"])
	quest_updated.emit(mission_id, "completed")
	GameState.change_state(GameState.HState.MAIN_MENU)
	#check_all_quests_completed()

# ✅ Verifica si todas las misiones están completas
func check_all_quests_completed():
	for mission in active_quests.values():
		if mission["state"] != "completed":
			return
	print("🎉 ¡Todas las misiones completadas!")
	all_quests_completed.emit()

# 🔍 Marcar zonas en el mapa
func mark_zone(pos, color):
	print(" mark zone position: ", pos)
	# print("mark zone", pos , color)
	if pos == null:
		print("⚠️ Intento de marcar una zona con posición nula")
		return

	var marker = ColorRect.new()
	marker.color = color
	marker.size = Vector2(32, 32)  # Ajusta el tamaño según el grid del TileMap
	marker.position = pos
	marker.z_index = 10
	add_child(marker)

	# Guardamos las referencias para borrarlos después
	if color == Color(1, 0.5, 0.7, 0.5): 
		start_markers.append(marker)
	else:
		end_markers.append(marker)

# 🗑️ Borrar marcadores previos
func clear_markers():
	for marker in start_markers + end_markers:
		if marker:
			marker.queue_free()
	start_markers.clear()
	end_markers.clear()
	
# Busca al jugador en la escena y le asigna la primera misión activa
func assign_first_quest_to_player():
	var player = get_node_or_null("/root/World/Player")  # Ajusta la ruta según tu jerarquía
	if player and active_quests.size() > 0:
		var first_quest_id = active_quests.keys()[0]
		player.assign_quest(first_quest_id)

func print_active_quests():
	for quest in active_quests:
		print("Misión:", quest["title"], "Estado:", quest["status"])
