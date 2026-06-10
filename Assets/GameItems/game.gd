extends Node2D

var currentEnergy = 100
var hp := 5
var max_hp := 5

@onready var bar = $CanvasLayer/TextureProgressBar
@onready var candle = $CanvasLayer/Candle
@onready var flame = $CanvasLayer/Candle/Flame

var flame_position = [
	Vector2(0, 0), # 0 hp
	Vector2(0, 1000), # 1 hp
	Vector2(50, 200), # 2 hp
	Vector2(0, -350), # 3 hp
	Vector2(50, -1300), # 4 hp
	Vector2(50, -2100), # 5 hp
]

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func update_hp():
	candle.frame = hp
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		flame,
		"position",
		flame_position[hp],
		0.25
	)
	print("HP:", hp, " target:", flame_position[hp])
	
func take_damage(amount: int):
	hp = max(hp - amount, 0)
	update_hp()
	
	if hp == 0:
		game_over()
		

func game_over():
	print("Dedówa")
	flame.hide()
	

func _ready():
	candle.frame = 5
	flame.play("fire")
	$Area2D.collected.connect(_on_energy_collected) 
	bar.value = currentEnergy
	update_bar_texture()

func _on_energy_collected():
	var target_value = currentEnergy - 30
	
	take_damage(4)
	
	var tween = create_tween()
	tween.tween_property(
		$CanvasLayer/TextureProgressBar,
		"value",
		target_value,
		0.2
	)
	
	currentEnergy = target_value
	
	await tween.finished
	update_bar_texture()
	
	

func update_bar_texture():
	if currentEnergy == 100:
		bar.texture_progress = preload("res://Assets/Sprites/Character/UI/Energy/FullEnergyBar.png")
	elif currentEnergy < 100:
		bar.texture_progress = preload("res://Assets/Sprites/Character/UI/Energy/Progress.png")
	
