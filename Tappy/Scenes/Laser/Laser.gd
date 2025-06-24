extends Area2D

@onready var flash_animation: AnimationPlayer = $"Flash Animation"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flash_animation.play("flash")
