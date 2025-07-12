extends PathFollow2D

@export var speed: float = 150.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# turn off sync to physics if using this to move objec position
	progress +=  speed *delta
	
