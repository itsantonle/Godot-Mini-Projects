extends Control

@onready var grid_container: GridContainer = $MC/VB/GridContainer
const LEVEL_BUTTON = preload("res://Scenes/LevelButton/LevelButton.tscn")

const LEVEL_LIMIT: int = 30 


func _unhandled_input(event: InputEvent) -> void:
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_grid()
	

	
		
func setup_grid() -> void: 
	for ln in range(1, LEVEL_LIMIT + 1 ): 
		var str_ln: String = str(ln)
		var lvl_button: LevelButton  = LEVEL_BUTTON.instantiate()
		# you need to call all the set up before the onready life cycle which is when you instantiate
		lvl_button.setup_display_text(str_ln)
		grid_container.add_child(lvl_button)
		
