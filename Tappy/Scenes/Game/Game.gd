extends Node2D

class_name  Game
# Called when the node enters the scene tree for the first time.
@onready var upper_point: Marker2D = $"Upper Point"
@onready var lower_point: Marker2D = $"Lower Point"
@onready var pipes: Node = $Pipes
@onready var spawn_timer: Timer = $SpawnTimer


const PIPE_SCENE = preload("res://Scenes/PipeScene/PipeScene.tscn")
var Y_RANGE_UPPER = 328
var Y_RANGE_LOWER = 602
var X_RANGE = 571
var X_OFFSET = randf_range(500, 1000)


		
func _ready() -> void:
	Y_RANGE_UPPER = upper_point.position.y
	Y_RANGE_LOWER = lower_point.position.y
	spawn_pipes()


func _enter_tree() -> void:
	# connnects signal to make sure they are all connected on time but can also be put on ready
	SignalHub.plane_died.connect(_on_plane_plane_died)


func spawn_pipes() -> void:
	var pipe_scene = PIPE_SCENE.instantiate()
	var y_position = randf_range(Y_RANGE_UPPER, Y_RANGE_LOWER)
	var x_position =X_RANGE
	var pipe_position = Vector2(x_position, y_position)
	pipe_scene.position = pipe_position
	pipes.add_child(pipe_scene)
	

func _on_spawn_timer_timeout() -> void:
	spawn_pipes()

func die() -> void: 
	spawn_timer.stop()
	set_process(false)
	
func _on_plane_plane_died() -> void:
	# useful method for stopping everything in a trees - cnn control which nodes are paused
	get_tree().paused = true
	
