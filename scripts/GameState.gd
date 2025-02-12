extends Node


signal state_changed(new_state: int)
signal game_paused(pause: bool)

var hud_scene : PackedScene
var hud_instance : Node

const HState = preload("res://scripts/game_enums.gd").HudState

var current_state = HState.MAIN_MENU

func _ready():
	# Cargar la escena HUD
	hud_scene = preload("res://scenes/HUD.tscn")
	hud_instance = hud_scene.instantiate()
	add_child(hud_instance)
	
	change_state(HState.MAIN_MENU)  # Estado inicial
	emit_signal("state_changed", HState.MAIN_MENU)

func emit_pause_signal(new_state):
	match new_state:
		GameState.HState.PAUSED:
			emit_signal("game_paused", true)
		GameState.HState.RESUME:
			emit_signal("game_paused", false)

# Función para cambiar de estado
func change_state(new_state):
	if current_state == new_state:
		return  # No hacer nada si es el mismo estado
	current_state = new_state
	emit_signal("state_changed", new_state)
	emit_pause_signal(new_state)
