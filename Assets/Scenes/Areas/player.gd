extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_frozen = false

func _physics_process(delta: float) -> void:
	
	# EQUIPMENT
	if Input.is_action_just_pressed("ui_focus_mode") and is_on_floor():
		is_frozen = !is_frozen
		
		if is_frozen:
			$ItemList.show()
			$SpriteHolder/AnimatedSprite2D.pause()
		else:
			$ItemList.hide()
			$SpriteHolder/AnimatedSprite2D.play("Idle")
	
	# FREEZING THE FRAME
	if is_frozen:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	# Start Animation TODO: ADD RUN, JUMP, HIT ANIMATIONS
	$SpriteHolder/AnimatedSprite2D.play("Idle")
		
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump input
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		$SpriteHolder/AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * (delta * 7))

	# Animations
	#if not is_on_floor():
		#$AnimatedSprite2D.play("Jump")
	#elif direction != 0:
		#$AnimatedSprite2D.play("Run")
	#else:
		#$AnimatedSprite2D.play("PetalsIdle")

	
	move_and_slide()
