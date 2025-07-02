extends Control

@onready var music: AudioStreamPlayer = $Music
@onready var main: Control = $Main
@onready var game_screen: Control = $GameScreen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_game_exit()

func _enter_tree() -> void:
	SignalHub.on_game_exit_pressed.connect(on_game_exit)
	SignalHub.on_level_selected.connect(on_level_select)

#region Signals
func on_game_exit() -> void: 
	SoundManager.play_sound(music, SoundManager.SOUND_MAIN_MENU)
	show_game(false)

func on_level_select(level:int) -> void: 
	SoundManager.play_sound(music, SoundManager.SOUND_IN_GAME)
	show_game(true)
	
func show_game(s:bool) -> void: 

	game_screen.visible = s 
	main.visible = !s
	
#endregion
