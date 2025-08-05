extends Area2D

# Esta función elimina el nodo cuando otro cuerpo entra en su área, lo que se usa para hacer desaparecer objetos al ser tocados.
func _on_body_entered(body: Node2D) -> void:
	queue_free()
	pass 
