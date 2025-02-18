extends Node

@onready var stats_widget = $StatsWidget/HUD
@onready var pause_menu = $PauseMenu/PauseMenuCLayer
@onready var main_menu: CanvasLayer = $MainMenu
@onready var dialogue_ui: CanvasLayer = $DialogueUI
@onready var sceneContainer: Node = $SceneContainer
@onready var controlSettings: Control = $ControlSettings

var currentScene

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # Permite que la UI funcione en pausa
	stats_widget.visible = false
	pause_menu.visible = false
	dialogue_ui.visible = false
	main_menu.visible = true
	controlSettings.visible = false
	
	if GameState:
		GameState.connect("state_changed", Callable(self, "_on_state_changed"))
	
func pause_scene(pause: bool):
	if not currentScene:
		return
	
	if pause:
		currentScene.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		currentScene.process_mode = Node.PROCESS_MODE_INHERIT
	

func load_scene(nScene):
	if currentScene:
		currentScene.queue_free()
		
	var newScene = load(nScene).instantiate()
	sceneContainer.add_child(newScene)
	currentScene = newScene
	
# Manejo de visibilidad de UI según el estado del juego
func _on_state_changed(new_state: int):
	match new_state:
		GameState.HState.MAIN_MENU:
			main_menu.visible = true
			stats_widget.visible = false
			pause_menu.visible = false
			controlSettings.visible = false
			pause_scene(true)
			#get_tree().paused = true
		GameState.HState.PLAYING:
			stats_widget.visible = true
			main_menu.visible = false
			pause_menu.visible = false
			controlSettings.visible = false
			load_scene("res://scenes/Game.tscn")
		GameState.HState.PAUSED:
			controlSettings.visible = false
			main_menu.visible = false
			stats_widget.visible = false
			pause_menu.visible = true
			pause_scene(true)
		GameState.HState.RESUME:
			pause_scene(false)
			stats_widget.visible = true
			main_menu.visible = false
			pause_menu.visible = false
			controlSettings.visible = false
		GameState.HState.DIALOGUE_OPEN:
			pause_scene(true)
		GameState.HState.DIALOGUE_CLOSE:
			pause_scene(false)
		GameState.HState.CONTROLS_OPEN:
			pause_scene(true)
			controlSettings.visible = true
			main_menu.visible = false
			pause_menu.visible = false
			stats_widget.visible = false
