extends Node

@onready var default_view = $DefautlView/HUD #Renombrar a stats_player_ui o algo asi
@onready var pause_menu = $PauseMenu/PauseMenuCLayer
@onready var shop = $ShopMenu
@onready var main_menu: CanvasLayer = $MainMenu
@onready var dialogue_ui: CanvasLayer = $DialogueUI

var game_scene : PackedScene
var game_instance : Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # Permite que la UI funcione en pausa
	default_view.visible = false
	pause_menu.visible = false
	shop.visible = false
	main_menu.visible = false
	dialogue_ui.visible = true
	
	
	game_scene = preload("res://high_way_tmap.tscn")
	# game_instance = game_scene.instantiate()
	
	if GameState:
		GameState.connect("state_changed", Callable(self, "_on_state_changed"))
		
func _pause(pause: bool):
	if is_inside_tree():
		get_tree().paused = pause
	
# Manejo de visibilidad de UI según el estado del juego
func _on_state_changed(new_state: int):
	match new_state:
		GameState.HState.MAIN_MENU:
			main_menu.visible = true
			default_view.visible = false
			shop.visible = false
			pause_menu.visible = false
			get_tree().paused = true
		GameState.HState.PLAYING:
			main_menu.visible = false
			shop.visible = false
			pause_menu.visible = false
			default_view.visible = true
			if is_inside_tree():
				get_tree().paused = false
				get_tree().change_scene_to_packed(game_scene)
		GameState.HState.PAUSED:
			main_menu.visible = false
			default_view.visible = false
			shop.visible = false
			pause_menu.visible = true
			_pause(true)
		GameState.HState.SHOP:
			shop.visible = true
		GameState.HState.RESUME:
			main_menu.visible = false
			shop.visible = false
			pause_menu.visible = false
			default_view.visible = true
			_pause(false)
		GameState.HState.DIALOGUE_OPEN:
			_pause(true)
		GameState.HState.DIALOGUE_CLOSE:
			_pause(false)
			
