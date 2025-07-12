extends AnimatedSprite2D

class_name Explosion
@onready var sound: AudioStreamPlayer2D = $Sound

func _ready() -> void:
	#randomizer is use to pick from 2 sounds
	sound.play()
func _on_animation_finished() -> void:
	queue_free()

	
