extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"): 
		print('exit')
		GameManager.load_main_scene()
