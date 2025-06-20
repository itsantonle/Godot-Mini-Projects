extends Node2D
# hold down control key
@onready var icon: Sprite2D = $Icon
@onready var icon_2: Sprite2D = $Icon2

# Called when the node enters the scene tree for the first time.
# if you have hold of a particular scence can grab or acces any nodes in that scene
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	icon.position.x += (50 * delta)
	icon.rotation_degrees += 120 * delta
