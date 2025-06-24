extends Control

# avoid preload many scense that causes a circular reference
# needs to be defined who's  first
@onready var game_over_label: Label = $"MarginContainer/Game Over Label"
@onready var press_space_label: Label = $"MarginContainer/Press Space Label"
@onready var game_over_timer: Timer = $"Game Over Timer"
@onready var score_label: Label = $"MarginContainer/Score Label"
@onready var background_music: AudioStreamPlayer = $BackgroundMusic
const GAME_OVER = preload("res://assets/audio/game_over.wav")

var _score = 0 



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"): 
		print("UHANDLED INPUT:: pressed exit")
		GameManager.load_main_scene()
	if event.is_action_pressed("Jump"): 
		if press_space_label.visible: 
			ScoreManager.high_score = _score
			print("RETURNED TO MENU VIA SPACE")
			GameManager.load_main_scene()
	
func _ready() -> void:
	_score = 0
	
	
func _enter_tree() -> void:
	SignalHub.plane_died.connect(showGameOver)
	SignalHub.on_point_scored.connect(point_scored)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func showGameOver() -> void: 
	print("Game over") 
	background_music.stop()
	background_music.stream = GAME_OVER
	background_music.play()
	game_over_label.show()
	game_over_timer.start()

	
func _on_game_over_timer_timeout() -> void:
	game_over_label.hide()
	press_space_label.show()

func point_scored() -> void: 
	background_music.play()
	_score += 1 
	score_label.text = "%04d" % _score
	


	
