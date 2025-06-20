extends Area2D
# this call the actual class with the collisiion and sprite, no need to select sprite
# part of this gem type 
# Called when the node enters the scene tree for the first time.
class_name Gem
#class that emits a custom signal 
signal gem_off_screen

const SPEED: float = 100.0
# get from the gatviewport rect

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += ( SPEED * delta)
	if position.y >= get_viewport_rect().end.y:
		#position.y = 0
		#var value = randf_range(0.0 + 48, 1152.0-48)
		#position.x = value
		
		#stop the engie invoeking the process 
		print("Gem falls off")
		gem_off_screen.emit()
		die()

func die() -> void: 
	# stps that delta for that particular instance 
	set_process(false) # always set this if game over so no unexpected movement
	queue_free()
	
func _on_area_entered(area: Area2D) -> void:
		print("Paddle hit gem")
		die()
		
