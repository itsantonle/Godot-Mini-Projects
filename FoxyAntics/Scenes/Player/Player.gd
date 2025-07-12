extends CharacterBody2D

class_name Player
#region constants
const GRAVITY: int = 690
const JUMP_POWER: int = 300
const RUN_SPEED: int = 120
const MAX_FALL: float = 350.0
const HURT_JUMP_VELOCITY: Vector2 = Vector2(0, -150.0)
#endregion

#region exported var
@export var fell_off_y: float = 100
@export var lives: int = 3
@export var run_speed: float = 120
@export var camera_min: Vector2 = Vector2(-10000, 10000)
@export var camera_max: Vector2 = Vector2(10000, -10000)
#endregion

#region onready and preload var
#audio
const JUMP_SOUND = preload("res://assets/sound/jump.wav")
const HURT_SOUND = preload("res://assets/sound/damage.wav")


@onready var sprite_img: Sprite2D = $SpriteImg
@onready var debug_label: Label = $"Debug Label"
# treat shooter like any other class
@onready var shooter: Shooter = $Shooter
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var hurt_timer: Timer = $HurtTimer
@onready var player_cam: Camera2D = $PlayerCam


#endregion

#region class var
# hurt 
var _is_hurt: bool = false 
var _invincible: bool = false 

#endregion


#region built_in methods

func _ready() -> void:
	print("PLAYER READY")
	set_camera_limits()
	call_deferred("late_init")
	
func set_camera_limits()-> void: 
	player_cam.limit_bottom = camera_min.y
	player_cam.limit_left = camera_min.x
	player_cam.limit_top = camera_max.y
	player_cam.limit_right = camera_max.x
	
	
func late_init() -> void: 
	SignalHub.emit_on_player_hit(lives, false)
	
func _enter_tree() -> void:
	add_to_group(Constants.PLAYER_GROUP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	#ProjectSettings.get_setting("physics/2d/default_gravity")
		velocity.y += GRAVITY * delta
		
		#movement
		get_input()
		velocity.y = clampf(velocity.y, -JUMP_POWER, MAX_FALL)
		
		move_and_slide()
		update_debug_label()
		fallen_off()

	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"): 
		shoot()
#endregion	
			 
#region utils 
# music
func play_effect(effect: AudioStream) -> void: 
	sound.stop()
	sound.stream = effect
	sound.play()
	
#input
func get_input() -> void: 
	if _is_hurt: 
		return 
	if is_on_floor(): 
		jump()	
	run()
	
#actions	
func shoot() -> void: 
	var dir: Vector2 = Vector2.LEFT if sprite_img.flip_h else Vector2.RIGHT
	shooter.shoot(dir)

	
func jump() -> void: 
	if Input.is_action_just_pressed("jump"): 
		velocity. y = -JUMP_POWER
		play_effect(JUMP_SOUND)

func run() -> void: 
	var direction = Input.get_axis("left", "right")
	velocity.x = run_speed * direction 
	if 	!is_equal_approx(velocity.x, 0): 
		sprite_img.flip_h = velocity.x < 0 

#misc
func update_debug_label() -> void: 
	var ds: String = ""
	ds += "Floor: %s LV: %s\n" % [is_on_floor(), lives]
	ds += "V: %.1f, %.1f\n" % [velocity.x, velocity.y]
	ds += "P: %.1f, %.1f" % [global_position.x, global_position.y]
	debug_label.text = ds
	
func fallen_off() -> void: 
	if global_position.y < fell_off_y: 
		return
	reduce_lives(lives)

# hurt section
func go_invincible() -> void: 
	if _invincible:
		return 
	_invincible = true
	
	var tween: Tween = create_tween()
	# loop the tween to make ast x seconds
	for _i in range(3):
		tween.tween_property(sprite_img, "modulate", Color("#ffffff", 0.0), 0.5)
		tween.tween_property(sprite_img, "modulate", Color("#ffffff", 1.0), 0.5)
	
	tween.tween_property(self, "_invincible", false, 0)

func reduce_lives(reduction: int) -> bool: 
	lives -= reduction
	SignalHub.emit_on_player_hit(lives, true)
	if lives <= 0: 
	
		set_physics_process(false)
		# return false if dead
		return false 
	return true 

func apply_hurt_jump() -> void: 
	_is_hurt = true
	velocity = HURT_JUMP_VELOCITY
	play_effect(HURT_SOUND)
	hurt_timer.start()
	
	
func apply_hit() -> void: 
	if _invincible:
		return 
	if reduce_lives(1) == false: 
		return 
	go_invincible()
	apply_hurt_jump()

	

#endregion


#region signals
func _on_hitbox_area_entered(area: Area2D) -> void:
	call_deferred("apply_hit")
	

func _on_hurt_timer_timeout() -> void:
	_is_hurt = false 
	
#endregion
