extends Node2D

var currentHealthBarProgress = 100
@onready var bar = $CanvasLayer/TextureProgressBar

func _ready():
	$Area2D.collected.connect(_on_heal_collected) 
	bar.value = currentHealthBarProgress
	update_bar_texture()

func _on_heal_collected():
	var target_value = currentHealthBarProgress - 30
	
	var tween = create_tween()
	tween.tween_property(
		$CanvasLayer/TextureProgressBar,
		"value",
		target_value,
		0.2
	)
	
	currentHealthBarProgress = target_value
	
	await tween.finished
	update_bar_texture()
	
	

func update_bar_texture():
	if currentHealthBarProgress == 100:
		bar.texture_progress = preload("res://Assets/Sprites/Character/UI/HealthBar/FullHealthBar.png")
	elif currentHealthBarProgress < 100:
		bar.texture_progress = preload("res://Assets/Sprites/Character/UI/HealthBar/Progress.png")
	
