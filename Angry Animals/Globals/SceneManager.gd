extends Node

const MAIN = preload("res://Scenes/Main/Main.tscn")

func navigate_to_main() -> void: 
	get_tree().change_scene_to_packed(MAIN)
