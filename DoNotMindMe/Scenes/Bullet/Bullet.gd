extends Area2D

const SPEED: float = 250.0
var _dir: Vector2 = Vector2.ZERO


func _ready() -> void:
	var p = get_tree().get_first_node_in_group(Player.GROUP_NAME)
	if !p: 
		queue_free()
	else: 
		_dir = global_position.direction_to(p.global_position)  * SPEED 
		look_at(p.global_position)

func _process(delta: float) -> void:
	global_position += _dir* delta


func _on_body_entered(body: Node2D) -> void:
	queue_free()


func _on_screen_notifier_screen_exited() -> void:
	queue_free()
