extends Node
const MAIN = preload("res://Scenes/Main/Main.tscn")
const GAME = preload("res://Scenes/Game/Game.tscn")
const TRANSITION = preload("res://Scenes/Transition/Transition.tscn")
var next_scene: PackedScene 
const FADE_TRANSITION = preload("res://Scenes/FadeTransition/FadeTransition.tscn")

func add_fade_in() ->void: 
	var ftb = FADE_TRANSITION.instantiate()
	add_child(ftb)
	
func load_main_scene()-> void: 
	next_scene = MAIN
	add_fade_in()
	#get_tree().change_scene_to_packed(TRANSITION)

func load_game_scene() -> void: 
	next_scene = GAME
	add_fade_in()
	#get_tree().change_scene_to_packed(TRANSITION)
	
