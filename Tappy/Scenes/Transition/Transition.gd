extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# good if you just want to wait without a signal
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_packed(GameManager.next_scene)
