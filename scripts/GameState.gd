extends Node


signal state_changed(new_state: int)

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

# Función para cambiar de estado
func change_state(new_state):
	if current_state == new_state:
		return  # No hacer nada si es el mismo estado
	current_state = new_state
	emit_signal("state_changed", new_state)
