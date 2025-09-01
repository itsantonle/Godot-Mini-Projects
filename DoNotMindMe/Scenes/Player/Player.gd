extends CharacterBody2D

class_name Player 
const SPEED: float = 200.0
const GROUP_NAME: String = "Player"

func _enter_tree() -> void:
	add_to_group(GROUP_NAME)
	
func get_input() -> Vector2: 
	var nv: Vector2 = Vector2.ZERO
	nv.x = Input.get_axis("ui_left", "ui_right")
	nv.y = Input.get_axis("ui_up", "ui_down")
	return nv.normalized()
	
func _physics_process(delta: float) -> void:
	velocity = get_input() * SPEED
	rotation = velocity.angle()
	move_and_slide()
	
	
