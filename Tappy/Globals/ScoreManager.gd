extends Node

# this an alias to C:\Users\User\AppData\Roaming\Godot\app_userdata\Tappy
const SCORES_PATH: String = "user://tappy.tres"
var _high_score:int = 0

var high_score:int: 
	get: 
		return _high_score
	set(value): 
		if value > _high_score: 
			_high_score = value 
			save_highscore()
	
func _ready() -> void:
	Load_highscore()

func Load_highscore() -> void: 
	if ResourceLoader.exists(SCORES_PATH): 
		var hsr: HighScoreResource = load(SCORES_PATH)
		if hsr: 
			_high_score = hsr.high_score
			pass
	
func save_highscore() -> void: 
	# creates an instance of the hsr everytime 
	var hsr: HighScoreResource = HighScoreResource.new()
	hsr.high_score = _high_score
	ResourceSaver.save(hsr, SCORES_PATH )
	
