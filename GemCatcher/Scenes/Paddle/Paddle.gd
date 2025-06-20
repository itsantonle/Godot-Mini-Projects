extends Area2D
const MOVEMENT_SPEED = 500
const MARGIN = 52

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# continuous presses are different fron input and unhandled input, use a singleton

		# prevent from overlapping
	if position.x <= get_viewport_rect().position.x + MARGIN or position.x >= get_viewport_rect().end.x - MARGIN: 
		# set variable to either the min or max if overlap
		position.x = clampf(position.x, get_viewport_rect().position.x + MARGIN,  get_viewport_rect().end.x - MARGIN)
		
	#if Input.is_action_pressed("move_left"): 
		#position.x -= MOVEMENT_SPEED * delta
	#elif Input.is_action_pressed("move_rigjht"): 
		#position.x += MOVEMENT_SPEED * delta
		
	var movement : float = Input.get_axis("move_left", "move_rigjht")
	# the left parament is multipled by negavtive 1 and the right by positive
	position.x += MOVEMENT_SPEED * delta * movement
	


func _on_area_entered(area: Area2D) -> void:
	print("Collide with some paddle class", area.name)
