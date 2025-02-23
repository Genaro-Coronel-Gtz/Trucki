extends Node

enum JsonType {
	Array,
	Dictionary
}

func coords_to_vector2(coords: String) -> Vector2:
	var componentes = coords.strip_edges().split(",")
	
	if componentes.size() != 2:
		print("Error: La cadena no tiene el formato correcto.")
		return Vector2.ZERO
	
	# Convertir las componentes a números flotantes
	var x = componentes[0].to_float()
	var y = componentes[1].to_float()
	
	return Vector2(x, y)
	

func read_json(file_path: String, type: JsonType = JsonType.Array) -> Variant:
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file == null:
		print("Error al abrir el archivo:", FileAccess.get_open_error())
		if type == JsonType.Array:
			return [] as Array
		else:
			return {} as Dictionary

	var json_string = file.get_as_text()  # Leer el contenido del archivo
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("Error al parsear JSON")
		if type == JsonType.Array:
			return [] as Array
		else:
			return {} as Dictionary

	if type == JsonType.Array:
		return json.get_data() as Array  # Retorna los datos convertidos en un diccionario
	else: 
		return json.get_data() as Dictionary
