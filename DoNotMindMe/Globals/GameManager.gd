extends Node

const LEVEL = preload("res://Scenes/Level/Level.tscn")
const MAIN = preload("res://Scenes/Main/Main.tscn")

func load_main_scene() -> void: 
	get_tree().change_scene_to_packed(MAIN)
	
func load_level_scene() -> void: 
	get_tree().change_scene_to_packed(LEVEL)
