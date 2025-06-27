extends Control

class_name GameInterface 
var _attempts: int = -1
@onready var attempts_label: Label = $MarginContainer/VBoxContainer/AttemptsLabel
@onready var level_complete_label: VBoxContainer = $MarginContainer/LevelComplete
@onready var music: AudioStreamPlayer2D = $Music
@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"): 
		SceneManager.navigate_to_main()
		
	if event.is_action_pressed("ui_accept") and level_complete_label.is_visible_in_tree(): 
		SceneManager.navigate_to_main()

func _ready() -> void:
	level_label.text = "Level " + ScoreManager.level_selected
	update_attempts()

func _enter_tree() -> void:
	SignalHub.on_attempt_made.connect(update_attempts)
	SignalHub.on_cup_destroyed.connect(on_cup_destroyed)
	
	
func update_attempts() -> void: 
	_attempts +=1
	attempts_label.text = "Attempt: "  + str(_attempts)

func on_cup_destroyed(remaining_cups:int) -> void: 
	if remaining_cups <= 0: 
		level_complete_label.show()
		music.play()
		ScoreManager.set_score_for_level(ScoreManager.level_selected, _attempts)
		
		
		
		
	
