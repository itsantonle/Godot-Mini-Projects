extends TextureButton
# property in the insperctor to play with settings
class_name LevelButton

@export var level_number: String = "1"

@onready var level_label: Label = $MC/VBoxContainer/LevelNumber
@onready var score_label: Label = $MC/VBoxContainer/Score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_label.text = level_number
	score_label.text = str(ScoreManager.get_level_best(level_number))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	scale = Vector2(1.1, 1.1)

func _on_mouse_exited() -> void:
	scale = Vector2(1.0, 1.0)


func _on_pressed() -> void:
	ScoreManager.level_selected = level_number
	var button_level_path: String = "res://Scenes/LevelBase/Level%s.tscn" % level_number
	get_tree().change_scene_to_file(button_level_path)
