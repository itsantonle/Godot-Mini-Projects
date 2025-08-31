extends Node2D

func _physics_process(delta: float) -> void:
	position.x += delta  * 10.0
