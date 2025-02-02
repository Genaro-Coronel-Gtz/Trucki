extends CanvasLayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewportContainer = $SubViewportContainer
	var screen_size = get_viewport().get_visible_rect().size
	viewportContainer.position = Vector2(0, screen_size.y - viewportContainer.size.y)
