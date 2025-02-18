extends Control

@onready var action_list := $Panel/ActionList
@onready var assign_button := $Panel/AssignButton
@onready var waiting_label := $Panel/WaitingLabel

var selected_action: String = ""
var current_event : InputEvent = null  # Variable para guardar el evento

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # Permite que la UI funcione en pausa
	# Obtener la referencia al InputManager desde la jerarquía de la escena
	#input_manager = get_node("/root/HUD/InputManagerNode")  # Ruta al nodo que tiene el script InputManager.gd
	populate_action_list()
	await get_tree().create_timer(1.5).timeout  # Espera un momento después de cargar
	action_list.item_selected.connect(_on_ActionList_item_selected)
	assign_button.pressed.connect(_on_AssignButton_pressed)
	selected_action = action_list.get_item_text(0)


# Llenar la lista de acciones disponibles en la UI
func populate_action_list():
	action_list.clear()
	#for action in ["ui_up", "ui_left", "ui_right", "ui_down", "ui_cancel", "ui_show_map", "ui_start"]:
	for action in [
			"ui_up", "ui_left", "ui_right", 
			"ui_down", "ui_cancel", "ui_show_map",
			"ui_start"]:
		# print(" action: added ", action)
		action_list.add_item(action)
		var index = action_list.get_item_count() - 1
		action_list.set_item_metadata(index, action)  # Asignar metadatos
		
	#print("Total items in ActionList:", action_list.get_item_count())  # Depuración

# Detectar selección de acción en la UI
func _on_ActionList_item_selected(index):
	print("Item selected ", index)
	selected_action = action_list.get_item_text(index)
	print(" selected action ", selected_action)
	assign_button.disabled = false

# Iniciar el proceso de reasignación de tecla/botón
func _on_AssignButton_pressed():
	waiting_label.visible = true
	await get_tree().create_timer(0.1).timeout  # Pequeña espera para evitar capturar el clic en el botón
	assign_button.disabled = true
	assign_input()

# Esperar a que el jugador presione una tecla o botón de joystick
func assign_input():
	print("Entra en assign_input")
	current_event = null  # Reiniciar el evento actual
	waiting_label.text = "Presiona una tecla o botón"  # Mostrar mensaje de espera

	# Esperar hasta que se capture un evento de entrada
	while current_event == null:
		await get_tree().process_frame
		
	print(" current event:  ", current_event)

	# Una vez capturado el evento, asignarlo
	if current_event is InputEventKey or current_event is InputEventJoypadButton:
		# Mostrar la tecla o el botón en el Label
		var keyPressed = get_event_name(current_event)
		waiting_label.text = keyPressed

		# Asignar el evento al InputManager
		InputManager.signal_action_binding(selected_action, current_event)

	elif current_event is InputEventJoypadMotion:
		# Para el caso de movimiento de joystick, mostrar el eje y valor
		var motionData = get_event_name(current_event)
		waiting_label.text = motionData
		
		# Asignar el evento al InputManager
		InputManager.signal_action_binding(selected_action, current_event)

	# Habilitar el botón de asignación nuevamente
	assign_button.disabled = false

# Función para obtener el nombre del evento (tecla o botón)
func get_event_name(event: InputEvent) -> String:
	if event is InputEventKey:
		return "Tecla: " + OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventJoypadButton:
		return "Botón Joystick: " + str(event.button_index)
	elif event is InputEventJoypadMotion:
		return "Joystick: " + str(event.axis) + " " + ("Positivo" if event.axis_value > 0 else "Negativo")
	return "Evento no reconocido"

#Capturar eventos de entrada
func _input(event: InputEvent):
	if event is InputEventKey or event is InputEventJoypadButton:
		current_event = event
	elif event is InputEventJoypadMotion:
		# Filtrar solo movimientos significativos
		if abs(event.axis_value) > 0.5:
			current_event = event
