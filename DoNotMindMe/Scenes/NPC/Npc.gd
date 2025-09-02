extends CharacterBody2D

enum  EnemyState {Patrolling, Chasing, Searching}

@export var patrol_points:NodePath
@export var field_of_view_range: float =  60.0
#nodepath are the green dollar sign text, holds path to an object

@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var debug_label: Label = $DebugLabel
@onready var player_detect: RayCast2D = $PlayerDetect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var warning: Sprite2D = $Warning
@onready var gasp_sound: AudioStreamPlayer2D = $GaspSound
@onready var shoot_timer: Timer = $ShootTimer
@onready var laser_sound: AudioStreamPlayer2D = $LaserSound




const BULLET = preload("res://Scenes/Bullet/Bullet.tscn")
const SPEED: Dictionary[EnemyState, float] = {
	EnemyState.Patrolling : 60.0, 
	EnemyState.Chasing: 100.0, 
	EnemyState.Searching: 80.0, 
}


const FOV: Dictionary[EnemyState, float] = {
	EnemyState.Patrolling : 60.0, 
	EnemyState.Chasing: 120.0, 
	EnemyState.Searching: 100.0, 
}

var _waypoints: Array[Vector2] = []
var _current_wp: int = 0
var _state: EnemyState = EnemyState.Patrolling
var _player_ref: Player



func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("set_target"):
		nav_agent.target_position = get_global_mouse_position()
	
func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Player.GROUP_NAME)
	if !_player_ref: 
		queue_free()
	create_wp()
	
	
func _physics_process(delta: float) -> void:
	detect_player()
	process_behavior()
	update_movement()
	update_raycast()
	set_label()

func create_wp() -> void: 
	# use the get_node to get node from nodepath 
	for child in get_node(patrol_points).get_children(): 
		_waypoints.append(child.global_position)

# get calculated filed of vision
func get_field_of_view() -> float: 
	var dtp: Vector2 = global_position.direction_to(_player_ref.global_position)
	# the angle towars the player from where the npc is facing
	var atp: float = transform.x.angle_to(dtp)
	return rad_to_deg(atp)

func update_raycast() -> void: 
	# you can get raycat to directly look at 
	player_detect.look_at(_player_ref.global_position)
	
func player_is_visible() -> bool: 
	return player_detect.get_collider() is Player
	
func can_see_player() -> bool: 
	return abs(get_field_of_view()) < FOV[_state] and player_is_visible()
	
func navigate_wp() -> void: 
	if _waypoints.is_empty() or !_waypoints: 
		return
	nav_agent.target_position = _waypoints[_current_wp]
	_current_wp = (_current_wp + 1) % _waypoints.size()
	
	
func update_movement() -> void: 
	if nav_agent.is_navigation_finished(): 
		return 
		
	var npp: Vector2 = nav_agent.get_next_path_position()
	rotation = global_position.direction_to(npp).angle()
	#nav_agent.velocity = transform.x * SPEED
	velocity = transform.x * SPEED[_state]
	move_and_slide()
	
func process_patrolling() -> void: 
	if nav_agent.is_navigation_finished(): 
		navigate_wp()
	

	
func process_chasing() -> void: 
	nav_agent.target_position  = _player_ref.global_position
		
func process_searching() -> void: 
	if nav_agent.is_navigation_finished(): 
		set_state(EnemyState.Patrolling)
		
func process_behavior() -> void: 
	match  _state: 
		EnemyState.Patrolling: 
			process_patrolling()
		EnemyState.Chasing: 
			process_chasing()
		EnemyState.Searching: 
			process_searching()

func set_state(new_state: EnemyState) -> void: 
	if new_state == _state: return 
	if _state == EnemyState.Searching: 
		warning.hide()
		
	if new_state == EnemyState.Searching: 
		warning.show()
	elif new_state == EnemyState.Chasing: 
		gasp_sound.play()
		animation_player.play("alert")
	elif new_state == EnemyState.Patrolling: 
		animation_player.play("RESET")
		
	_state = new_state

func detect_player() -> void: 
	if can_see_player(): 
		set_state(EnemyState.Chasing)
	elif _state == EnemyState.Chasing: 
		set_state(EnemyState.Searching)
			
func set_label() -> void: 
	var s:String = "FIN_NAV: %s\n " % nav_agent.is_navigation_finished()
	s+= "STATE: %s ANGLEL %.0f:\n" % [EnemyState.keys()[_state], get_field_of_view()]
	s += "PLAYER_VIS: %s\n" % player_is_visible()
	s+= "CAN_SEE: %s\n" % can_see_player()
	s+= "TAR: %s" % nav_agent.target_position
	
	debug_label.text = s
	debug_label.rotation = -rotation


func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity 
	move_and_slide()

func shoot_at_player() -> void: 
	if _state != EnemyState.Chasing: 
		return 
	laser_sound.play()
	var nb = BULLET.instantiate()
	nb.global_position = global_position
	# add the child but not to the enemy when you want to make independet parts
	# that doen't move according to parent
	get_tree().current_scene.call_deferred("add_child", nb)
	
func _on_shoot_timer_timeout() -> void:
	
	shoot_at_player()
