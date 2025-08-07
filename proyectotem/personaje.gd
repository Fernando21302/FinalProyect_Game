# Script para controlar un personaje 2D con movimiento, salto, gravedad y animaciones.

extends CharacterBody2D

var velocidad = 100   # Velocidad horizontal del personaje
var brinco = -70      # Fuerza de salto (valor negativo para subir)
var gravedad = 100    # Fuerza de gravedad que afecta al personaje
var point = 0         # Contador de puntos o monedas recogidas

func _ready():
	add_to_group("jugador")  # Añade este nodo al grupo "jugador" para identificarlo fácilmente

func _physics_process(delta):
	var direccion = Input.get_axis("ui_left", "ui_right")  # Detecta entrada horizontal (-1 a 1)
	velocity.x = direccion * velocidad  # Aplica velocidad horizontal según entrada
	
	# Aplicar gravedad si no está en el suelo
	if not is_on_floor():
		velocity.y += gravedad * delta
	
	# Salto: si se presiona "arriba" y está en el suelo, aplica impulso vertical
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = brinco
	
	# Control de animaciones según estado y movimiento
	if not is_on_floor():
		if velocity.y < 0:  # Subiendo en el salto
			$AnimationPlayer.play("salto")
		else:  # Cayendo
			$AnimationPlayer.play("caida")
	else:
		if direccion < 0:
			$AnimationPlayer.play("caminariz")  # Caminar hacia la izquierda
		elif direccion > 0:
			$AnimationPlayer.play("caminar")    # Caminar hacia la derecha
		else:
			$AnimationPlayer.play("idle")       # Quieto
	
	move_and_slide()  # Mueve el personaje con colisiones y gravedad

func _input(event):
	if event.is_action_pressed("guardar"):  
		SaveData.guardar_datos(point, get_tree().current_scene.scene_file_path)

	if event.is_action_pressed("cargar"):  
		var datos = SaveData.cargar_datos()
		if "monedas" in datos and "nivel" in datos:
			point = datos["monedas"]
			get_node("Camera2D/HUD").update_count(point)
			get_tree().change_scene_to_file(datos["nivel"])


# Reinicia la escena actual si un cuerpo entra en el área de reset (como trampas)
func _on_reset_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()

# Cambia a la escena "lv_2" si un cuerpo entra en la puerta (door)
func _on_door_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://lv_2.tscn")

# Suma un punto y actualiza el HUD cuando se recoge una moneda
func Pickup_coin():
	point += 1
	get_node("Camera2D/HUD").update_count(point)

# Cambia a la escena "lv_2" si el personaje entra en contacto con "picos_2" (posible zona de daño o portal)
func _on_picos_2_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://lv_2.tscn")

# Cambia a la escena "fin" si el personaje entra en la segunda puerta
func _on_door_2_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://fin.tscn")
	
	
func _on_secret_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://lv_3.tscn")
