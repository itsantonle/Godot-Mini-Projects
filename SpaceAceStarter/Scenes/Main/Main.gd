extends Control



#region signals
func _on_play_button_pressed() -> void:
	GameManager.load_level_scene()


func _on_exit_button_pressed() -> void:
	# quit the game by exiting the tree
	get_tree().quit()
	
#endregion
