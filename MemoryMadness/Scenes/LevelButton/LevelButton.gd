extends TextureButton


@export var level_number:int = 1 
@onready var label: Label = $Label
@onready var sound: AudioStreamPlayer = $Sound

func _ready() -> void:
	var ls: LevelSettingResource  = LevelDataSelector.get_level_setting(level_number)
	if !ls: 
		# get rid of null levels 
		queue_free()
	else:
		label.text = "%dx%d" % [ls.get_rows(), ls.get_cols()]


func _on_pressed() -> void:
	SoundManager.play_button_click(sound)
	SignalHub.emit_on_level_selected(level_number)
