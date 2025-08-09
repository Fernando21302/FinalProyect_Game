extends Node

var save_path = "user://savegame.save"

func guardar_datos(monedas, nivel, posicion):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		var datos = {
			"monedas": monedas,
			"nivel": nivel,
			"posicion": {"x": posicion.x, "y": posicion.y}
		}
		file.store_var(datos)
		file.close()

func cargar_datos():
	if not FileAccess.file_exists(save_path):
		return {}
	var file = FileAccess.open(save_path, FileAccess.READ)
	var datos = file.get_var()
	file.close()
	return datos
