extends CollisionShape2D
# Esta función recarga la escena actual si el cuerpo que entra pertenece al grupo "player",
# lo que puede usarse para reiniciar el nivel cuando el jugador toca un área peligrosa, como una trampa o un vacío.
func _on_body_entered(body):

	if body.is_in_group("player"): 
		get_tree().reload_current_scene()
