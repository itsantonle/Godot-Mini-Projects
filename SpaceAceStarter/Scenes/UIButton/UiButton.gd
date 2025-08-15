extends TextureButton
class_name UIButton
#exports
@export var text: String = "Set Me"

#variables
@onready var text_label: Label = $TextLabel


#region built in functions
func _ready() -> void:
	text_label.text = text
#region end 
