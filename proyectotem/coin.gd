extends Area2D


func _on_body_entered(body: Node2D) -> void:
	# Verificar si el cuerpo está en el grupo "jugador"
	if body.is_in_group("jugador"):
		body.Pickup_coin()
		queue_free()
