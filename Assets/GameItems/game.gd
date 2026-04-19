extends Node2D

var currentHealthBarProgress = 100

func _ready(): 
	$Area2D.collected.connect(_on_heal_collected) 
	$CanvasLayer/TextureProgressBar.value = 100

func _on_heal_collected():
	var target_value = currentHealthBarProgress - 40
	
	var tween = create_tween()
	tween.tween_property(
		$CanvasLayer/TextureProgressBar,
		"value",
		target_value,
		0.2
	)
	
	currentHealthBarProgress = target_value
