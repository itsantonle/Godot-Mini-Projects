extends Control

@onready var tile_grid: GridContainer = $HBoxContainer/TileGrid
const MEMORY_TILE = preload("res://Scenes/MemoryTile/MemoryTile.tscn")
@onready var sound: AudioStreamPlayer = $Sound
@onready var scorer: Scorer = $Scorer
@onready var moves_label: Label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/MovesLabel
@onready var pairs_label: Label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/PairsLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _enter_tree() -> void:
	SignalHub.on_level_selected.connect(on_level_select)

func _process(delta: float) -> void:
	moves_label.text = scorer.get_moves_made_str()
	pairs_label.text = scorer.get_pairs_made_str()


func add_memory_tile(image: Texture2D, frame: Texture2D) -> void:
	var mt: MemoryTile = MEMORY_TILE.instantiate()
	tile_grid.add_child(mt)
	mt.setup(image, frame)
	
	
func on_level_select(level:int) -> void: 
	# access static at class level
	var lds: LevelDataSelector = LevelDataSelector.get_level_selection(level)
	var fi: Texture2D = ImageManager.get_random_frame_image()
	tile_grid.columns = lds.get_num_cols()
	
	for im in lds.get_eelected_images(): 
		add_memory_tile(im, fi)
		
	scorer.clear_new_game(lds.get_target_pairs())
	

func _on_exit_pressed() -> void:
	for t in tile_grid.get_children(): 
			t.queue_free()
	SoundManager.play_sound(sound, SoundManager.SOUND_SELECT_BUTTON)
	SignalHub.emit_on_game_exit_pressed()
	
