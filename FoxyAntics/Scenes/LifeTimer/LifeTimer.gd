extends Node

@export var  life_time: float = 20.0
#utility nodes should be utilized
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# this is a customized self managing node, wait for timeout then queue free the parent
	await get_tree().create_timer(life_time).timeout
	get_parent().call_deferred("queue_free")
	
