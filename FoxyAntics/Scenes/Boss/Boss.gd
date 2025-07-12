extends Node2D

@export var lives:int = 2
@export var points: int = 5


@onready var animation_tree: AnimationTree = $AnimationTree
@onready var hitbox: Area2D = $Visuals/Hitbox
@onready var shooter: Shooter = $Visuals/Shooter
@onready var visuals: Node2D = $Visuals
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

var _invincible: bool = false 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func activate_collisions() -> void: 
	hitbox.set_deferred("monitoring", true )
	hitbox.set_deferred("monitorable", true )
	
func tween_hit() -> void: 
	var tween: Tween = create_tween()
	tween.tween_property(visuals, "position", Vector2.ZERO, 1.0)

func set_invincible(on: bool) -> void: 
	_invincible = on

func reduce_lives() -> void: 
	lives -= 1 
	if lives <= 0: 
		SignalHub.emit_on_scored(points)
		SignalHub.emit_on_boss_killed()
		queue_free()
		
		
func take_damage() -> void: 
	if _invincible: 
		return 
	set_invincible(true)
	state_machine.travel("hit")
	tween_hit()
	reduce_lives()

func _on_trigger_area_entered(area: Area2D) -> void:
	# you can use array notation to get parameters 
	animation_tree["parameters/conditions/on_trigger"] = true 

func shoot_player() -> void: 
	

	# remember that the shooter shoots from where it is, so you must make it a child of visuals
	# nodes do that and must be a chldren to their moving parents
	shooter.shoot_at_player()

	

func _on_hitbox_area_entered(area: Area2D) -> void:
	take_damage()
