extends Node2D

const SOURCE_ID: int = 0
@onready var floor_tiles: TileMapLayer = $TileLayers/Floor
@onready var walls_tiles: TileMapLayer = $TileLayers/Walls
@onready var targets_tiles: TileMapLayer = $TileLayers/Targets
@onready var boxes_tiles: TileMapLayer = $TileLayers/Boxes
@onready var tile_layers: Node2D = $TileLayers
@onready var camera_2d: Camera2D = $Camera2D
@onready var player: AnimatedSprite2D = $Player
@onready var game_ui: GameUI = $CanvasLayer2/GameUI

var _tile_size: int = 0 
var _player_tile: Vector2i = Vector2i.ZERO
var _game_over: bool = false 
var _level: String  = "1"
var _moves_made: int = 0

func get_input_direction() -> Vector2i: 
	var md: Vector2i = Vector2i.ZERO
	
	if Input.is_action_just_pressed("ui_left"): 
		md = Vector2i.LEFT
		player.flip_h = true 
	elif Input.is_action_just_pressed("ui_right"): 
		md = Vector2i.RIGHT
		player.flip_h = false 
	elif Input.is_action_just_pressed("ui_down"): 
		md = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_up"): 
		md = Vector2i.UP
		
	return md
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"): 
		print("EXIT")
		GameManager.load_main_scene()
		
	if event.is_action_pressed("reload"): 
		print("RELOAD")
		# use this for reloading current scene
		get_tree().reload_current_scene()
		
	if _game_over: 
		return 
		
	var md: Vector2i = get_input_direction()
	if md != Vector2i.ZERO: 
		player_move(md)
		
func cell_is_wall(cell: Vector2i) -> bool: 
	return true if cell in walls_tiles.get_used_cells() else false 
	
func cell_is_box(cell: Vector2i) -> bool: 
	return cell in boxes_tiles.get_used_cells()

func cell_is_empty(cell: Vector2i) -> bool: 
	return !cell_is_box(cell) and !cell_is_wall(cell)
	
func box_can_move(box_tile: Vector2i, dir: Vector2i) -> bool: 
	# can move if there's space 
	return cell_is_empty(box_tile + dir)
	
func move_box(box_tile: Vector2i, md: Vector2i) -> void: 
	var dest: Vector2i  = box_tile + md
	boxes_tiles.erase_cell(box_tile)
	# determine target layer type
	var tlt: TileLayers.LayerType  = TileLayers.LayerType.Boxes
	
	if dest in targets_tiles.get_used_cells(): 
		tlt = TileLayers.LayerType.TargetBoxes
		
	
	boxes_tiles.set_cell(dest, SOURCE_ID,get_atlas_coord(tlt))
	
func check_game_state() -> void: 
	for t in targets_tiles.get_used_cells(): 
		if !cell_is_box(t): 
			return 
	_game_over = true 
	print(_moves_made)
	var best_score:bool = GameManager.level_completed(_level, _moves_made)
	game_ui.game_over(_moves_made, best_score)
func player_move(md: Vector2i) -> void: 
		var dest: Vector2i = _player_tile + md
		
		# is dest a wall? Ask what type of layer is it.
		
		# if wall- return 
		if cell_is_wall(dest): 
			return 
			
		# cell is box
		if cell_is_box(dest) and !box_can_move(dest, md):  return
		if cell_is_box(dest): 
			move_box(dest, md)
			
		# cell is empty 
		place_plaer_on_tile(dest)
		_moves_made +=1
		game_ui.set_moves_label(_moves_made)
		
		#check the game state
		check_game_state()
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("LEVEL LOADED: " + GameManager.get_level_selected())
	_tile_size = floor_tiles.tile_set.tile_size.x
	game_ui.set_moves_label(_moves_made) 	
	setup_level()

func place_plaer_on_tile(tile_coord: Vector2i) -> void: 
	player.position = Vector2(tile_coord * _tile_size)
	_player_tile = tile_coord
	
func get_atlas_coord(lt: TileLayers.LayerType) -> Vector2i: 
	match lt:
		TileLayers.LayerType.Walls: 
			return Vector2i(2,0) 
		TileLayers.LayerType.Floor: 
			return Vector2i(randi_range(3,8), 0  )
		TileLayers.LayerType.Targets:
			return Vector2i(9,0)
		TileLayers.LayerType.TargetBoxes:
			return Vector2i(0,0)
		TileLayers.LayerType.Boxes: 
			return Vector2i(1,0)
		_: 
			return Vector2i.ZERO

func add_tile(lt: TileLayers.LayerType, tc: Vector2i, map: TileMapLayer) -> void: 
	var atlas_coord: Vector2i = get_atlas_coord(lt)
	map.set_cell(tc,SOURCE_ID, atlas_coord )
	
func setup_layer(lt: TileLayers.LayerType, map: TileMapLayer, ll: LevelLayout) -> void:
	# get the coord tiles for the layer 
	var tiles: Array[Vector2i] = ll.get_tiles_for_layer(lt)
	for tc in tiles: 
		add_tile(lt, tc, map)
	
func clear_tiles() -> void: 
	for tl in tile_layers.get_children(): 
		if tl is TileMapLayer:
			tl.clear()
		
func move_camera() -> void: 
	var tmr: Rect2i = floor_tiles.get_used_rect()
	print(tmr)
	# multiply by the tile size in order to get good posiioning 
	camera_2d.position = tmr.get_center() * _tile_size
	
func setup_level() ->void: 
	_level = GameManager.get_level_selected()
	var level_layout: LevelLayout = LevelData.get_level_data(_level)
	clear_tiles()
	setup_layer(TileLayers.LayerType.Floor, floor_tiles, level_layout)
	setup_layer(TileLayers.LayerType.Walls, walls_tiles, level_layout)
	setup_layer(TileLayers.LayerType.Targets, targets_tiles, level_layout)
	setup_layer(TileLayers.LayerType.Boxes, boxes_tiles, level_layout)
	setup_layer(TileLayers.LayerType.TargetBoxes, targets_tiles, level_layout)
	place_plaer_on_tile(level_layout.get_player_start())
	move_camera()
	
	
	

#region notes
func n() -> void: 
	# get all the user up cells by that floor tile
	print(floor_tiles.get_used_cells())
	
	# get the primeter eocompasig all the cells, nice for getting areas (NOT THE COORDINATE THE AREA)
	print(floor_tiles.get_used_rect())
	
	# you can get the center as well
	print(floor_tiles.get_used_rect().get_center())
	
	# get the property of a tile in px
	print(floor_tiles.tile_set.tile_size.x)
	
	#erasing a tile 
	floor_tiles.erase_cell(Vector2i(7,4))
	#setting a tile requires the tile coordinate and the atlas coordinate and source 0of tile you want to set
	floor_tiles.set_cell(Vector2i(7,4), 0, Vector2i(2,0))
	
	#clear all tiles from the layer
	floor_tiles.clear()
#endregion
