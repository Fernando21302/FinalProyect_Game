# Script para una plataforma con distintos comportamientos según su tipo:
# fija, oscilatoria, frágil o de rebote.

extends Area2D

enum TipoPlataforma {FIJA, OSCILATORIA, FRAGIL, REBOTE}
# Define los tipos posibles de plataforma.

@export var tipo: TipoPlataforma = TipoPlataforma.FIJA
# Permite elegir el tipo de plataforma desde el editor, por defecto es fija.

@export var fuerza_rebote := 2.0
# Fuerza con la que el jugador será rebotado si la plataforma es de tipo REBOTE.

func _ready():
	actualizar_plataforma()  # Configura la plataforma según su tipo al iniciar.
	monitorable = true       # Permite que otros nodos puedan detectar esta área.
	monitoring = true        # Activa la detección de cuerpos que entren al área.

func actualizar_plataforma():
	# Ejecuta acciones específicas según el tipo de plataforma.
	match tipo:
		TipoPlataforma.OSCILATORIA:
			oscilar()  # Inicia el movimiento oscilatorio si es plataforma oscilatoria.

func _on_body_entered(body: Node2D) -> void:
	# Cuando un cuerpo entra en la plataforma, se ejecuta esta función.
	if body.is_in_group("jugador"):
		match tipo:
			TipoPlataforma.FRAGIL:
				# Si es frágil, espera 0.5 segundos y luego se destruye.
				await get_tree().create_timer(0.5).timeout
				queue_free()
			TipoPlataforma.REBOTE:
				# Si es de rebote, intenta usar método personalizado 'puede_rebotar' en el cuerpo.
				# Si no existe, aplica rebote modificando la velocidad vertical.
				if body.has_method("puede_rebotar"):
					body.puede_rebotar(fuerza_rebote)
				else:
					body.velocity.y = body.brinco * fuerza_rebote
	pass  # Esta línea no hace nada y puede eliminarse.

func oscilar():
	# Crea una animación con tween que mueve la plataforma horizontalmente 100 unidades
	# hacia la derecha y luego hacia la izquierda de forma continua.
	var tween = create_tween()
	tween.tween_property(self, "position:x", position.x + 100, 2)
	tween.tween_property(self, "position:x", position.x - 100, 2)
	tween.set_loops()

	
