extends Area2D


# Esta función se ejecuta cuando un cuerpo entra en el área (Area2D).
# Al activarse, cambia la escena actual a "lv_2.tscn", permitiendo avanzar de nivel o área.
func _on_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://lv_2.tscn")
	pass # Esta línea no hace nada y puede eliminarse.
