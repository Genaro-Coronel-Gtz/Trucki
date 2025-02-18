extends Node

signal state_changed(new_state: int)
signal game_paused(pause: bool)

var hud_scene : PackedScene
var hud_instance : Node
var current_state = HState.MAIN_MENU

const HState = preload("res://scripts/game_enums.gd").HudState

func _ready():
	change_state(HState.MAIN_MENU)  # Estado inicial
	emit_signal("state_changed", HState.MAIN_MENU)

# Función para cambiar de estado
func change_state(new_state):
	if current_state == new_state:
		return  # No hacer nada si es el mismo estado
	current_state = new_state
	emit_signal("state_changed", new_state)
	emit_pause_signal(new_state)

func emit_pause_signal(new_state):
	match new_state:
		GameState.HState.PAUSED:
			emit_signal("game_paused", true)
		GameState.HState.RESUME:
			emit_signal("game_paused", false)
