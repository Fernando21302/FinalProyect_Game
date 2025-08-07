extends Node

const SAVE_PATH := "res://save_file.json"

var datos_guardados := {
	"monedas": 0,
	"nivel": ""
}

func guardar_datos(monedas: int, nivel: String) -> void:
	datos_guardados["monedas"] = monedas
	datos_guardados["nivel"] = nivel

	var json_string = JSON.new().stringify(datos_guardados)
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
	print("Juego guardado.")

func cargar_datos() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No hay archivo de guardado.")
		return {}

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var contenido := file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(contenido)

	if error != OK:
		print("Error al convertir JSON.")
		return {}

	datos_guardados = json.get_data()
	print("Datos cargados.")
	return datos_guardados
