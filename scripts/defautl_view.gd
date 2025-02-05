extends Control

@onready var speed_label: Label = $HUD/SpeedLabel
@onready var position_label: Label = $HUD/Position
@onready var helath_label: Label = $HUD/Health

func _ready():
	if GameData:
		GameData.connect("stats_changed", Callable(self, "_on_stats_changed"))

func _on_stats_changed(stats: Dictionary):
	speed_label.text = "Velocidad: " + str(stats.speed)
	position_label.text = "X: " + str(stats.position.x) + " Y: " + str(stats.position.y)
	helath_label.text = "Salud: " + str(stats.health)
