extends EnemyBase

@onready var jump_timer: Timer = $JumpTimer

var _seen_player:bool = false 
var _can_jump: bool = false 
const JUMP_VELOCITY: Vector2=  Vector2(100, -150)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity.y += delta * _gravity

	apply_jump()
	move_and_slide()
	if is_on_floor(): 
		velocity.x = 0
		animated_sprite_2d.play("idle")
		
	flip_me()


	
#region util

	

func apply_jump() -> void: 
	if !is_on_floor()  or !_can_jump or !_seen_player: 
		return
	velocity = JUMP_VELOCITY if animated_sprite_2d.flip_h else Vector2(-JUMP_VELOCITY.x, JUMP_VELOCITY.y )
	_can_jump = false
	start_timer()
	animated_sprite_2d.play("jump")
		
func start_timer() -> void: 
	#start a timer with a random wait time
	var wait_time: float = randf_range(2, 3) 
	jump_timer.wait_time = wait_time
	print("jump timer start")
	
	jump_timer.start()
	
#endregion
#region signals stuff
func _on_jump_timer_timeout() -> void:
	_can_jump = true 
	
	
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if !_seen_player: 
		_seen_player = true
		print("seen player")
		start_timer()

#endregion
