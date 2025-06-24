extends Node2D

class_name  PipeScene
const GAME = preload("res://Scenes/Game/Game.tscn")
const SPEED = 120
const MARGIN = 100
@onready var laser: Area2D = $Laser

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= SPEED* delta
	
	if position.x <= get_viewport_rect().position.x - MARGIN: 
		die()

func die() -> void: 
	set_process(false)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()
	


func _on_pipe_body_entered(body: Node2D) -> void:
	if body is GamePlane: 
		print("Colided")
		body.die()
		
		
func _on_laser_body_entered(body: Node2D) -> void:
	# disconnect so it only scores one (this is for each instance)
	if body is GamePlane: 
		laser.body_entered.disconnect(_on_laser_body_entered)
		print("point scored")
		SignalHub.emit_on_point_scored()
