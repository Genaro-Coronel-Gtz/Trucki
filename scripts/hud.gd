extends Node

@onready var default_view = $DefautlView #Renombrar a stats_player_ui o algo asi
@onready var pause_menu = $PauseMenu
@onready var shop = $ShopMenu
@onready var main_menu: CanvasLayer = $MainMenu

var game_scene : PackedScene
var game_instance : Node

func _ready():
	default_view.visible = false
	pause_menu.visible = false
	shop.visible = false
	main_menu.visible = false
	
	game_scene = preload("res://high_way_tmap.tscn")
	game_instance = game_scene.instantiate()
	
	if GameState:
		GameState.connect("state_changed", Callable(self, "_on_state_changed"))
		
# Manejo de visibilidad de UI según el estado del juego
func _on_state_changed(new_state: int):
	match new_state:
		GameState.State.MAIN_MENU:
			main_menu.visible = true
		GameState.State.PLAYING:
			main_menu.visible = false
			default_view.visible = false
			if is_inside_tree():
				get_tree().change_scene_to_packed(game_scene)
			else: 
				print(" este nodo ya no esta en el arbol de escenas")
		GameState.State.PAUSED:
			print(" menu paused showing")
			pause_menu.visible = true
		GameState.State.SHOP:
			shop.visible = true
