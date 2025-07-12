extends EnemyBase
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var was_on_wall := false

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity.y += delta * _gravity
	velocity.x = speed if animated_sprite_2d.flip_h else -speed

	var now_on_wall := is_on_wall()
	if (now_on_wall and !was_on_wall) or !ray_cast_2d.is_colliding():
		flip_me()
	was_on_wall = now_on_wall

	move_and_slide()

func flip_me() -> void: 
	if is_on_wall() or !ray_cast_2d.is_colliding(): 
		animated_sprite_2d.flip_h  = !animated_sprite_2d.flip_h
		ray_cast_2d.position.x = -ray_cast_2d.position.x
