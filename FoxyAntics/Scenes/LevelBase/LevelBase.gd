extends Node2D
const ENEMY_BULLET = preload("res://Scenes/Bullets/EnemyBullet.tscn")
@onready var player: Player = $Player


func add_bullet() -> void: 
	var en_bul = ENEMY_BULLET.instantiate()
	en_bul.global_position = player.global_position  + Vector2(10, 20)
	add_child(en_bul)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test_bullet"): 
		add_bullet()
	

func _ready() -> void:
	get_tree().paused = false 
