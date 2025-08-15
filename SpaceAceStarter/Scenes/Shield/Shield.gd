extends Area2D

class_name Shield

#exports
@export var start_health:int = 5 

#onreadys
@onready var timer: Timer = $Timer
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

#class variables
var _health: int = start_health

func _enter_tree() -> void:
	SignalHub.on_player_hits_power_up.connect(on_player_hits_power_up)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	disable_shield()
	
func disable_shield() ->void: 
	timer.stop()
	can_be_detected(false)
	

func can_be_detected(cond:bool) -> void: 
	SpaceUtils.toggle_area2d(self, cond)
	if cond == false: 
		sprite_2d.hide()
	else: 
		sprite_2d.show()
		
	
func enable_shield() -> void: 
	timer.start()
	_health = start_health
	animation_player.play("RESET")
	can_be_detected(true)
	sound.play()
	

	
func hit() -> void: 
	animation_player.play("hit")
	_health -= 1 
	if _health <= 0: 
		disable_shield()
	
#region signals

func _on_area_entered(area: Area2D) -> void:
	hit()


func _on_timer_timeout() -> void:
	disable_shield()

func on_player_hits_power_up(type: PowerUp.PowerUpType):
	if type == PowerUp.PowerUpType.Shield: 
		enable_shield()
	
#region end 
