extends Node2D
const EXPLODE = preload("res://assets/explode.wav")
const GEM = preload("res://Scenes/Gem/Gem.tscn")
const MARGIN = 70
# class level variable
var _score = 0


@onready var spawn_timer: Timer = $SpawnTimer
@onready var paddle: Area2D = $Paddle
@onready var score_sound: AudioStreamPlayer2D = $"Score Sound"
@onready var sound: AudioStreamPlayer = $Sound
@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	score_label.text = ("%03d" % _score)
	spawn_gem()
	
func spawn_gem() ->void: 
	var new_gem:Gem = GEM.instantiate()
	var x_post: float = randf_range(get_viewport_rect().position.x + MARGIN, get_viewport_rect().end.x - MARGIN)
	new_gem.position = Vector2(x_post, -MARGIN)
	# you can connect to signals 
	new_gem.gem_off_screen.connect(_on_gem_gem_off_screen)
	add_child(new_gem)

func stop_all(): 
	sound.stop()
	# change the music from the bg sound node 
	sound.stream = EXPLODE
	sound.play()
	spawn_timer.stop()
	paddle.set_process(false)
	for child in get_children(): 
		if child is Gem: 
			child.set_process(false)
		
	
func _on_paddle_area_entered(area: Area2D) -> void:
	_score += 1
	score_label.text =  ("%03d" % _score)
	if !score_sound.playing: 
		score_sound.position = area.position
		score_sound.play()


func _on_gem_gem_off_screen() -> void:
	stop_all()


func _on_timer_timeout() -> void:
	spawn_gem()
