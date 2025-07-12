extends EnemyBase

@export var fly_speed: Vector2 = Vector2(35,15)
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var direction_timer: Timer = $DirectionTimer
@onready var shooter: Shooter = $Shooter

# if it needs knot know obj type instantiate as child
var _fly_direction: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity = _fly_direction
	move_and_slide()
	shoot()
	# shoot logic here 

#region logic
func fly_to_player() -> void: 
	#var flipped: bool = true if _player_ref.global_position.x > global_position.x else false
	#animated_sprite_2d.flip_h = flipped
	flip_me()
	var x_dir: float = 1.0 if animated_sprite_2d.flip_h else -1.0
	# multiply vectors 
	_fly_direction = Vector2(x_dir, 1.0) * fly_speed
	velocity = _fly_direction
	 
	
func shoot() -> void: 
	if player_detector.is_colliding(): 
		# shoot towarsd a certain position
		shooter.shoot_at_player()
		

#endregion
#region signals
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play("fly")
	fly_to_player()
	direction_timer.start()
	

func _on_direction_timer_timeout() -> void:
	print("direction timer timeout")
	fly_to_player()
#endregion
