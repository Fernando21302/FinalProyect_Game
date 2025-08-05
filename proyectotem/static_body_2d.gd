# Script para plataformas con diferentes tipos que afectan su comportamiento y color.
# Soporta plataformas fijas, oscilatorias, frágiles y de rebote.

extends Area2D

enum TipoPlataforma {FIJA, OSCILATORIA, FRAGIL, REBOTE}
# Definición de tipos de plataforma.

@export var tipo: TipoPlataforma = TipoPlataforma.FIJA
# Permite seleccionar el tipo de plataforma desde el editor (por defecto fija).

@export var fuerza_rebote := 2.0
# Intensidad del rebote aplicado si la plataforma es del tipo REBOTE.

func _ready():
	actualizar_plataforma()  # Inicializa la plataforma según su tipo.
	monitorable = true       # Permite que el área detecte cuerpos.
	monitoring = true        # Activa la detección de colisiones.

func actualizar_plataforma():
	# Cambia el color del sprite y activa comportamientos según el tipo de plataforma.
	match tipo:
		TipoPlataforma.FIJA:
			$Sprite2D.modulate = Color.GREEN  # Verde para plataforma fija.
		TipoPlataforma.OSCILATORIA:
			$Sprite2D.modulate = Color.BLUE   # Azul para oscilatoria.
			oscilar()                         # Inicia el movimiento vertical oscilatorio.
		TipoPlataforma.FRAGIL:
			$Sprite2D.modulate = Color.RED    # Rojo para plataforma frágil.
		TipoPlataforma.REBOTE:
			$Sprite2D.modulate = Color.YELLOW # Amarillo para plataforma de rebote.

func _on_body_entered(body: Node2D) -> void:
	# Detecta cuando un cuerpo entra en la plataforma.
	if body.is_in_group("jugador"):
		match tipo:
			TipoPlataforma.FRAGIL:
				# Espera medio segundo y luego destruye la plataforma.
				await get_tree().create_timer(0.5).timeout
				queue_free()
			TipoPlataforma.REBOTE:
				# Si el cuerpo tiene el método 'puede_rebotar', lo llama con fuerza_rebote.
				# Si no, aplica directamente una velocidad vertical modificada.
				if body.has_method("puede_rebotar"):
					body.puede_rebotar(fuerza_rebote)
				else:
					body.velocity.y = body.brinco * fuerza_rebote
	pass  # Esta línea no hace nada y puede eliminarse.

func oscilar():
	# Crea un tween que mueve la plataforma verticalmente 100 unidades hacia arriba y abajo en ciclos.
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y + 100, 2)
	tween.tween_property(self, "position:y", position.y - 100, 2)
	tween.set_loops()

	pass  # Esta línea no hace nada y puede eliminarse.
