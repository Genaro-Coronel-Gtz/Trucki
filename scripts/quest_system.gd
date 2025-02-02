extends Node

signal quest_updated(quest_id: String, new_state: String)
signal all_quests_completed

@export var tilemap: TileMap  # Referencia al TileMap si usas tiles
var start_markers = []  # Lista para marcar zonas de inicio
var end_markers = []  # Lista para marcar zonas de fin

func _ready():
	print("QuestSystem listo")

# 🚀 Iniciar nuevas misiones con zonas marcadas en el mapa
# Función para comenzar nuevas misiones
var active_quests = []  # Lista de misiones activas

# Función para comenzar nuevas misiones
func start_new_quests(level):
	active_quests.clear()  # Limpiar misiones previas
	var missions = level["missions"]
	for mission_data in missions:
		# Asegúrate de que 'mission_data' es un Dictionary
		if mission_data.has("id") and mission_data.has("title") and mission_data.has("description"):
			var mission = {
				"id": mission_data["id"],
				"title": mission_data["title"],
				"description": mission_data["description"],
				"state": "not_started",
				"start_pos": Vector2(),  # Esto podría venir del nivel si lo necesitas
				"end_pos": Vector2()  # Esto también podría ser asignado desde el nivel
			}
						# Si tienes posiciones de inicio y fin, puedes asignarlas aquí
			mission["start_pos"] = level.get("start_position", Vector2())  # O la posición de inicio del nivel
			mission["end_pos"] = level.get("end_position", Vector2())  # O la posición de fin del nivel

			# Llamar a mark_zone para marcar las zonas
			mark_zone(mission["start_pos"], Color(1, 0.5, 0.7, 0.5))  # Zona de inicio (rosado)
			mark_zone(mission["end_pos"], Color(0, 1, 0, 0.5))  # Zona de fin (verde)
			active_quests.append(mission)
		else:
			print("Error: La misión no tiene la estructura correcta:", mission_data)
	# print("Misiones cargadas: ", active_quests)
	print("Misiones cargadas")
	
# 🏁 Completar misión
func complete_quest(mission_id):
	if mission_id in active_quests:
		active_quests[mission_id]["state"] = "completed"
		print("✅ Misión completada:", active_quests[mission_id]["title"])
		quest_updated.emit(mission_id, "completed")
		check_all_quests_completed()

# ✅ Verifica si todas las misiones están completas
func check_all_quests_completed():
	for mission in active_quests.values():
		if mission["state"] != "completed":
			return
	print("🎉 ¡Todas las misiones completadas!")
	all_quests_completed.emit()

# 🔍 Marcar zonas en el mapa
func mark_zone(pos, color):
	print("mark zone", pos , color)
	if pos == null:
		print("⚠️ Intento de marcar una zona con posición nula")
		return

	var marker = ColorRect.new()
	marker.color = color
	marker.size = Vector2(32, 32)  # Ajusta el tamaño según el grid del TileMap
	marker.position = pos
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
