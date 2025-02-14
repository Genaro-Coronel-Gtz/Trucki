extends CanvasLayer

@onready var dialogue_label = $Panel/MarginContainer/VBoxContainer/DialogueLabel
@onready var options_container = $Panel/MarginContainer/VBoxContainer/OptionsContainer
@onready var dialogue_panel = $Panel  # Referencia al panel del diálogo
@onready var vBoxContainer = $Panel/MarginContainer/VBoxContainer
@onready var cooldown_timer = Timer.new()  # Timer para evitar reactivación inmediata

@export var bg_color: Color

var margin_offset: int = 20
var border_radius: int = 20
var dialogue_size: Vector2 = Vector2(400, 200)

var margin_offset_vector: Vector2 = Vector2(margin_offset, margin_offset)
var dialogue_open = false
var can_trigger_dialogue = true  # Controla si se puede mostrar el diálogo

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # Permite que la UI funcione en pausa
	DialogueManager.dialogue_started.connect(display_dialogue)
	DialogueManager.dialogue_ended.connect(hide_dialogue)
	hide_dialogue()  # Ocultar al inicio

	# Configurar el Timer
	add_child(cooldown_timer)
	cooldown_timer.wait_time = 2.0  # Tiempo de espera (2 segundos)
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_reset_dialogue_trigger)

# Mostrar diálogo con opciones
func display_dialogue(text, options):
	if dialogue_open or not can_trigger_dialogue:
		return

	dialogue_open = true
	can_trigger_dialogue = false  # Bloquea reactivación hasta que termine el cooldown

	dialogue_panel.visible = true
	visible = true 

	GameState.change_state(GameState.HState.DIALOGUE_OPEN)
	
	vBoxContainer.add_theme_constant_override("separation", 20)
	
	dialogue_label.text = text
	options_container.hide()

	# Limpiar opciones previas
	for child in options_container.get_children():
		child.queue_free()

	if options.size() > 0:
		options_container.show()
		for option in options:
			var button = Button.new()
			button.text = option["text"]
			button.connect("pressed", Callable(self, "_on_option_selected").bind(option))
			options_container.add_child(button)
	else:
		# Solo mostrar el botón "Aceptar" cuando no hay opciones ni acciones
		var accept_button = Button.new()
		accept_button.text = "Aceptar"
		accept_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		accept_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		accept_button.connect("pressed", Callable(self, "_on_option_selected").bind({"next": ""}))
		
		options_container.show()
		options_container.add_child(accept_button)

	# Centrar el diálogo después de mostrarlo
	_styleish_dialogue()

# Cuando se selecciona una opción
func _on_option_selected(option):
	DialogueManager.choose_option(option)

# Ocultar la UI del diálogo
func hide_dialogue():
	dialogue_open = false
	GameState.change_state(GameState.HState.DIALOGUE_CLOSE)
	visible = false
	dialogue_panel.visible = false
	
	# Inicia el cooldown para evitar que se vuelva a activar inmediatamente
	cooldown_timer.start()

func _reset_dialogue_trigger():
	can_trigger_dialogue = true  # Permite volver a mostrar el diálogo

func _styleish_dialogue():
	var style = StyleBoxFlat.new()
	
	style.bg_color = bg_color
	
	style.corner_radius_top_left = border_radius
	style.corner_radius_top_right = border_radius
	style.corner_radius_bottom_left = border_radius
	style.corner_radius_bottom_right = border_radius
	
	style.expand_margin_left = margin_offset
	style.expand_margin_right = margin_offset
	style.expand_margin_top = margin_offset
	style.expand_margin_bottom = margin_offset
	
	dialogue_panel.add_theme_stylebox_override("panel", style)
		
	dialogue_panel.custom_minimum_size = dialogue_size
	
	var viewport_size = get_viewport().get_visible_rect().size  # Tamaño del viewport
	dialogue_panel.position = (viewport_size - dialogue_panel.size - margin_offset_vector) / 2  # Centrar
