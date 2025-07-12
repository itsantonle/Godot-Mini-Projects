extends CharacterBody2D

class_name EnemyBase
const FALL_OFF_Y: int = 200
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var point: int = 1 
@export var speed: float = 30

var _gravity: float = 800
var _player_ref: Player 

func _ready() -> void:
	# get ref of player inside the tree
	_player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	if !_player_ref: 
		queue_free()
		

func _physics_process(delta: float) -> void:
	if global_position.y > FALL_OFF_Y:
		queue_free()

func flip_me() ->void :
	if(_player_ref): 
		animated_sprite_2d.flip_h = _player_ref.global_position.x > global_position.x
		
#region child signal inheritance
# override in child scene
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.
	
func die() -> void: 
		set_physics_process(false)
		queue_free()
		SignalHub.emit_on_scored(point)
		SignalHub.emit_on_create_object(global_position, Constants.ObjectType.EXPLOSION)
		SignalHub.emit_on_create_object(global_position, Constants.ObjectType.PICKUP)
		
		

# in thrms of the enemy dies when being hit by player 
func _on_hit_box_area_entered(area: Area2D) -> void:
	die()

#endregion
