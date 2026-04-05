extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_frozen = false
var is_attacking = false

## TODO: Start creating the map (soon I hope)

func _physics_process(delta: float) -> void:
	# Reduces brightness to stop it from triggering bloom
	$SpriteHolder/AnimatedSprite2D.modulate = Color(0.8, 0.8, 0.8, 1.0)	
	# EQUIPMENT toggle
	if Input.is_action_just_pressed("ui_focus_mode") and is_on_floor():
		is_frozen = !is_frozen
		if is_frozen:
			$ItemList.show()
			$SpriteHolder/AnimatedSprite2D.pause()
		else:
			$ItemList.hide()
			$SpriteHolder/AnimatedSprite2D.play("Idle")
	
	# Game Freeze
	if is_frozen:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Grawitacja
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Skok 
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		$SpriteHolder/AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * (delta * 7))

	# Atak
	if Input.is_action_just_pressed("ui_attack_right") and not is_attacking:
		attack()
	
	# Movement Animacje
	if not is_attacking:
		if is_on_floor():
			if abs(velocity.x) < 0.1:
				$SpriteHolder/AnimatedSprite2D.play("Idle")
			else:
				$SpriteHolder/AnimatedSprite2D.play("Run")
		else:
			if abs(velocity.x) < 0.1:
				$SpriteHolder/AnimatedSprite2D.play("Idle")
			else:
				$SpriteHolder/AnimatedSprite2D.play("Jump")
	move_and_slide()

# Funkcja obsługująca atak
func attack():
	is_attacking = true
	$SpriteHolder/AnimatedSprite2D.play("Attack")
	$SpriteHolder/AnimatedSprite2D.offset.y = 0
	
	await $SpriteHolder/AnimatedSprite2D.animation_finished
	
	$SpriteHolder/AnimatedSprite2D.offset.y = 270
	is_attacking = false
	
