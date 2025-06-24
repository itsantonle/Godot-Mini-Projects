extends CharacterBody2D
class_name GamePlane

#signal plane_died

var POWER = 350

var _gravity: float = ProjectSettings.get("physics/2d/default_gravity")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var plane_engine_sound: AudioStreamPlayer = $PlaneEngineSound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(_gravity)





func _physics_process(delta: float) -> void:
	fly(delta)
	move_and_slide()
	
# #don't loop animation taht you don't wnat to keep playing after the input)
	if is_on_floor(): 
		die()

func fly(delta: float) -> void: 
	# put velocity and delta is already taken into account in move and slide and  this is required for accelerating things
	#set the velocity (not the position, the speed)
	velocity.y += _gravity *delta
	# this is an impulse its instant 
	# is just pressed is good for repetitive movement with cooldown

	if Input.is_action_just_pressed("Jump"): 
		animation_player.play("jump")
		velocity.y =  -POWER
		
func die() -> void: 
	SignalHub.emit_on_plane_died()
	plane_engine_sound.stop()
	animated_sprite_2d.stop()
	set_physics_process(false)
	
	
	
