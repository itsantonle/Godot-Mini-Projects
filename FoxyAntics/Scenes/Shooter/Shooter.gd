extends Node2D
class_name Shooter

# exports
@export var speed:float = 50.0
@export var shoot_delay: float = 0.7
@export var bullet_key: Constants. ObjectType  = Constants.ObjectType.BULLET_PLAYER

@onready var shoot_timer: Timer = $ShootTimer

@onready var sound: AudioStreamPlayer2D = $Sound


var _can_shoot: bool = true 
var _player_ref: Player 

func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	shoot_timer.wait_time = shoot_delay

	


func _on_shoot_timer_timeout() -> void:
	_can_shoot = true

func shoot(direction: Vector2) -> void: 
	if !_can_shoot: 
		return 
	_can_shoot = false
	print("SHOOT: X: %d, Y: %d" %[direction.x, direction.y])
	shoot_timer.start()
	SignalHub.emit_on_create_bullet(global_position, direction, speed, bullet_key)
	sound.play()


# automatically shoot the player from inside shooter class
func shoot_at_player() -> void: 
	if !_player_ref: 
		return 
	shoot(global_position.direction_to(_player_ref.global_position))
