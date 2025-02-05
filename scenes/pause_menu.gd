extends Panel


@onready var saveBtn = $SaveButton
@onready var resumeBtn = $ResumeButton
@onready var mainMenuBtn = $MainMenuBtn

func _ready():
	# Crear botones dinámicamente en base a levels_data
	saveBtn.connect("pressed", Callable(self, "_save_data"))
	resumeBtn.connect("pressed", Callable(self, "_resume_game"))
	mainMenuBtn.connect("pressed", Callable(self, "_main_menu"))


func _resume_game() -> void:
	if GameState:
		GameState.change_state(GameState.State.RESUME)
	
func _save_data() -> void:
	GameData.save_game()
	
func _main_menu() -> void:
	if GameState:
		GameState.change_state(GameState.State.MAIN_MENU)
