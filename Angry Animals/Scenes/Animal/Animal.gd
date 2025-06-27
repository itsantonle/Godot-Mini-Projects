extends RigidBody2D
class_name Animal 

enum AnimalState {Ready, Drag, Release }
const DRAG_LIMIT_MAX: Vector2 = Vector2(0, 60)
const DRAG_LIMIT_MIN: Vector2 = Vector2(-60, 0)
const IMPULSE_MULT: float = 20.0 
const IMPULSE_MAX: float = 1200.0 

@onready var launch_sound: AudioStreamPlayer = $"Launch Sound"
@onready var stretch_sound: AudioStreamPlayer = $"Stretch Sound"
@onready var kick_sound: AudioStreamPlayer = $"Kick Sound"

@onready var arrow: Sprite2D = $Arrow
@onready var debug_label: Label = $"Debug Label"


var _state : AnimalState = AnimalState.Ready
var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _arrow_scale_x: float = 0 

#region input 
func _unhandled_input(event: InputEvent) -> void:
	if _state == AnimalState.Drag and event.is_action_released("drag"): 
	
		# call defer to end of the call to try to synce up to engine 
		call_deferred("change_state", AnimalState.Release)
		
#endregion
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()



func setup() -> void: 
	_arrow_scale_x = arrow.scale.x 
	arrow.hide()
	_start = position
	

func _physics_process(delta: float) -> void:
	handle_state()
	update_debug_label()
	

	
#endregion
#region misc	
func update_debug_label() -> void: 
	var ds = "ST:%s, SL:%s, FR:%s \n" % [
		AnimalState.keys()[_state],
		sleeping, freeze
	]
	ds += "_drag_start: %.1f, %.1f\n" % [_drag_start.x, _drag_start.y]
	ds += "_dragged_vector: %.1f, %.1f" % [_dragged_vector.x, _dragged_vector.y]
	debug_label.text = ds
	
#endregion

#region drag
func update_arrow_scale() -> void: 
	# use lerp to interpreate weight 
	var imp_len: float = calculate_impulse().length()
	var perc:float = clamp(imp_len/ IMPULSE_MAX, 0, 1)
	# interpolates between two values based on percetage
	arrow.scale.x = lerp(_arrow_scale_x, _arrow_scale_x * 2, perc)
	arrow.rotation = (_start - position).angle()
	
	
func start_dragging() -> void: 
	arrow.show()
	_drag_start = get_global_mouse_position()
	
func handle_dragging() -> void: 
	var new_drag_vector: Vector2 = get_global_mouse_position() - _drag_start
	new_drag_vector = new_drag_vector.clamp(DRAG_LIMIT_MIN, DRAG_LIMIT_MAX)
	
	var diff: Vector2 = new_drag_vector - _dragged_vector
	
	if diff.length() > 0  and !stretch_sound.playing: 
		stretch_sound.play()
		
	# snaps the new drag vector valus to this 
	_dragged_vector = new_drag_vector
	
	# set animal position 
	position = _start + _dragged_vector
	update_arrow_scale()
#endregion 	

#region release 


func calculate_impulse() -> Vector2: 
	#send impulse opposite direction 
	return _dragged_vector * -IMPULSE_MULT
	
func start_release() -> void: 
	arrow.hide()
	launch_sound.play()
	freeze = false 
	apply_central_impulse(calculate_impulse())
	SignalHub.emit_on_attempt_made()
#endregion

#region state
func handle_state() -> void: 
	match _state: 
		AnimalState.Drag: 
			handle_dragging()
			 
func change_state(new_state:AnimalState) -> void:
	if _state == new_state: 
		return 
	_state = new_state
	match _state: 
		AnimalState.Drag: 
			start_dragging()
		AnimalState.Release: 
			start_release()
			
	
#func start_dragging(event: InputEvent) -> void: 
	#if event.is_action_pressed("drag"): 
		#_state = AnimalState.Drag
		#_drag_start = get_global_mouse_position()
#endregion

#region gameover
func die() ->void: 
	SignalHub.emit_on_animal_died()
	queue_free()
	
#endregion

#region signals
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("drag") and _state == AnimalState.Ready: 
		change_state(AnimalState.Drag)
	



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()



func _on_sleeping_state_changed() -> void:
	if sleeping == true: 
		for body in get_colliding_bodies(): 
			if body is Cup:
				body.die()
				
	call_deferred("die")


func _on_body_entered(body: Node) -> void:
	if body is Cup and !kick_sound.playing: 
		kick_sound.play()
	
	#endregion
