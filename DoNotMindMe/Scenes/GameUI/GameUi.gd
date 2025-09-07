extends Control

@onready var score_label: Label = $MC/ScoreLabel
@onready var time_label: Label = $MC/TimeLabe
@onready var exit_label: Label = $MC/ExitLabel
@onready var go_label: Label = $ColorRect/GoLabel
@onready var color_rect: ColorRect = $ColorRect

var _time: float = 0 
var _pickups_count: int = 0 
var _collected: int = 0 


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"): 
		print('exit')
		GameManager.load_main_scene()

func _ready() -> void:
	get_tree().paused = false 
	SignalHub.on_pickup_collected.connect(on_pickup_collected)
	SignalHub.on_player_died.connect(on_player_died)
	SignalHub.on_exit.connect(on_exit)
	
	_pickups_count = get_tree().get_nodes_in_group(PickUp.GROUP_NAME).size()
	update_score()


func _process(delta: float) -> void:
	_time += delta
	time_label.text = "%.1f" % _time

func stop_game() -> void: 
	set_process(false)
	color_rect.show()
	get_tree().paused = true 
	
func on_player_died() -> void: 
	go_label.text = "Game Over"
	stop_game()
	
func on_exit() -> void: 
	go_label.text = "Well done! You took %.1f seconds" % _time
	stop_game()
	
func update_score() -> void: 
	score_label.text = "%s / %s" % [_collected, _pickups_count]
	
func on_pickup_collected() -> void: 
	_collected +=1
	update_score()
	if _collected == _pickups_count: 
		SignalHub.emit_on_show_exit()
		exit_label.show()
