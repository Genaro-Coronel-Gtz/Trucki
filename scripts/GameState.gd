extends Node

var current_state = State.MAIN_MENU
signal state_changed(new_state: int)

var hud_scene : PackedScene
var hud_instance : Node

enum State {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	SHOP,
	GAME_OVER,
	LOADING
}

func _ready():
	# Cargar la escena HUD
	hud_scene = preload("res://scenes/HUD.tscn")
	hud_instance = hud_scene.instantiate()
	add_child(hud_instance)
	
	change_state(State.MAIN_MENU)  # Estado inicial
	emit_signal("state_changed", State.MAIN_MENU)

# Función para cambiar de estado
func change_state(new_state):
	if current_state == new_state:
		return  # No hacer nada si es el mismo estado
	current_state = new_state
	emit_signal("state_changed", new_state)
