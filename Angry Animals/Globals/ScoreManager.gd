extends Node

const SCORES_PATH: String = "user://animals.tres"

var _level_scores: LevelScoreResource = null

var level_selected:String = "1": 
	get: 
		return level_selected
	set(value): 
		level_selected = value 
		
func _ready() -> void:
	load_scores()

func set_score_for_level(level: String, score: int) -> void: 
	_level_scores.update_level_score(level, score)
	save_scores()
	
func get_level_best(level:String) -> int: 
	# gives you an options type of soething or default
	return _level_scores.get_level_best(level)
	
func load_scores() -> void: 
	if ResourceLoader.exists(SCORES_PATH): 
		_level_scores=	load(SCORES_PATH)
		# protect against unparsables, do this if there is not leve-scores eitherways
	if !_level_scores: 
		_level_scores = LevelScoreResource.new()
	
func save_scores() -> void: 
	# new Resource + path 
	ResourceSaver.save(_level_scores, SCORES_PATH)
