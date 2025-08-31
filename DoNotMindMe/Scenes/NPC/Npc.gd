extends CharacterBody2D
@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var debug_label: Label = $DebugLabel

const SPEED: float = 100.0


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("set_target"):
		nav_agent.target_position = get_global_mouse_position()
	
func _ready() -> void:
	set_label()
func _physics_process(delta: float) -> void:
	update_navigation()
	set_label()

	
func update_navigation() -> void: 
	if nav_agent.is_navigation_finished(): 
		return 
		
	var npp: Vector2 = nav_agent.get_next_path_position()
	rotation = global_position.direction_to(npp).angle()
	#nav_agent.velocity = transform.x * SPEED
	velocity = transform.x * SPEED
	move_and_slide()
	
func set_label() -> void: 
	var s:String = "FIN_NAV: %s\n" % nav_agent.is_navigation_finished()
	s += "TG_REA: %s\n" % nav_agent.is_target_reached()
	s+= "TG_CAN_REA: %s\n" % nav_agent.is_target_reachable()
	s+= "TAR: %s" % nav_agent.target_position
	debug_label.text = s


func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity 
	move_and_slide()
