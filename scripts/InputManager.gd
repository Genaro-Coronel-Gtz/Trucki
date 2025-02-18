extends Node

const CONFIG_FILE := "res://input_settings.cfg"

var input_bindings: Dictionary = {}
var is_from_load: bool = true

# 🔹 Definimos los valores por defecto
var DEFAULT_BINDINGS := {
	"ui_up": InputEventKey.new(),
	"ui_left": InputEventKey.new(),
	"ui_right": InputEventKey.new(),
	"ui_down": InputEventKey.new(),
	"ui_show_map": InputEventKey.new(),
	"ui_cancel": InputEventKey.new(),
	"ui_start": InputEventJoypadButton.new(),
}

func _ready():
	print(" Ready de InputManager ")
	ensure_config_exists() 
	load_input_settings()

func signal_action_binding(action: String, event: InputEvent):
	is_from_load = false
	set_action_binding(action, event) 
	
func set_action_binding(action: String, event: InputEvent):
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	input_bindings[action] = serialize_event(event)  # Guardamos en formato string
	save_input_settings()

func save_input_settings():
	var config := ConfigFile.new()
	
	for action in input_bindings.keys():
		config.set_value("inputs", action, input_bindings[action])
	
	if !is_from_load:
		is_from_load = false
		config.save(CONFIG_FILE)
		

func load_input_settings():
	var config := ConfigFile.new()
	
	if config.load(CONFIG_FILE) != OK:
		return  

	for action in config.get_section_keys("inputs"):
		var event_data: String = config.get_value("inputs", action, "")
		var event: InputEvent = deserialize_event(event_data)
		
		if event:
			set_action_binding(action, event)

# Serializar InputEvent a String (Para guardar en el .cfg)
func serialize_event(event: InputEvent) -> String:
	if event is InputEventKey:
		return "KEY_" + OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventJoypadButton:
		return "JOY_BUTTON_" + str(event.button_index)
	elif event is InputEventJoypadMotion:
		return "JOY_AXIS_" + str(event.axis) + "_" + str(event.axis_value)
	return ""


# Deserializar String a InputEvent (Para cargar del .cfg)
func deserialize_event(event_data: String) -> InputEvent:
	if event_data.begins_with("KEY_"):
		var event := InputEventKey.new()
		event.physical_keycode = OS.find_keycode_from_string(event_data.replace("KEY_", ""))
		return event
	elif event_data.begins_with("JOY_BUTTON_"):
		var event := InputEventJoypadButton.new()
		event.button_index = event_data.split("_")[-1].to_int()
		return event
	elif event_data.begins_with("JOY_AXIS_"):
		var parts = event_data.split("_")
		var event := InputEventJoypadMotion.new()
		event.axis = parts[2].to_int()
		event.axis_value = parts[3].to_float()
		return event
	return null


# 🔹 Verificar si el archivo de configuración existe y crearlo con valores por defecto si no
func ensure_config_exists():
	print(" ensure configure exists")
	var config := ConfigFile.new()
	
	if config.load(CONFIG_FILE) != OK:
		print(" Archivo de configuración no encontrado. Creando con valores por defecto...")

		DEFAULT_BINDINGS["ui_up"].physical_keycode = KEY_A
		DEFAULT_BINDINGS["ui_left"].physical_keycode = KEY_B
		DEFAULT_BINDINGS["ui_right"].physical_keycode = KEY_C
		DEFAULT_BINDINGS["ui_down"].physical_keycode = KEY_D
		DEFAULT_BINDINGS["ui_cancel"].physical_keycode = KEY_E
		DEFAULT_BINDINGS["ui_show_map"].physical_keycode = KEY_SPACE
		DEFAULT_BINDINGS["ui_start"].button_index = JOY_BUTTON_A
		
		for action in DEFAULT_BINDINGS.keys():
			input_bindings[action] = serialize_event(DEFAULT_BINDINGS[action])
			config.set_value("inputs", action, input_bindings[action])

		config.save(CONFIG_FILE)
