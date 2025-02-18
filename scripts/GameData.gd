extends Node

signal stats_changed(new_stats: Dictionary)

const SAVE_PATH = "res://data/savegame.json"

var player_position: Vector2 = Vector2(0, 0)

var stats = {
	"health": 100,
	"rewards": 0,
	"postion": player_position
} 
#metodos para compartir data dinamicamente

func set_stats(new_stats: Dictionary):
	stats = new_stats
	emit_signal("stats_changed", stats)

func get_stats() -> Dictionary:
	return stats

# Metodos para persistencia

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(stats, "\t"))  # Guarda con formato JSON
		file.close()
		print("✅ Progreso guardado:", stats)
	else:
		print("❌ Error al guardar el juego")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("⚠️ No hay archivo de guardado, se usará el progreso por defecto")
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		if data:
			stats = data
			print("📂 Progreso cargado:", stats)
		else:
			print("❌ Error al leer el archivo JSON")
		file.close()
	else:
		print("❌ No se pudo abrir el archivo de guardado")

func reset_game():
	stats = {
		"health": 100,
		"rewards": 0,
		"postion": player_position
	} 
	save_game()
	print("🔄 Juego reseteado")
