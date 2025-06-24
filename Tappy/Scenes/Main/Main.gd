extends Control


#func _input(event: InputEvent) -> void:
	##only invoked if there's an input to process, recommedn for sporadic
	## echo repeated key event when holding down key. second param
	#if event.is_action_pressed("Jump"): 
		#print(event)
		#get_viewport().set_input_as_handled()
		
@onready var high_score: Label = $MarginContainer/Number

func _unhandled_input(event: InputEvent) -> void:
	#used to handle overlapping presses
	if event.is_action_pressed("Jump"): 
		print("unhandled:: ", event)
		GameManager.load_game_scene()
		
		
# Called when the node enters the scene tree for the first time.
# Look at the parent node to avoid conflicts on on ready
func _ready() -> void:
	get_tree().paused = false
	high_score.text = "%04d" % ScoreManager.high_score
	


# don't use the typical input if not in game and is not really checked for each frame
