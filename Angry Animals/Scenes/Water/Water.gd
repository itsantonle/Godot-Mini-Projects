extends Area2D
class_name Water 
@onready var splash: AudioStreamPlayer2D = $Splash



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Animal: 
		splash.position = body.position
		splash.play()
	
		
