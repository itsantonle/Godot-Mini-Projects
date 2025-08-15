extends Node2D
class_name  Explosion

#constants
const EXPLOSION_SOUNDS: Array[AudioStream] = [
preload("res://assets/sounds/explosions/sfx_exp_medium1.wav"),
preload("res://assets/sounds/explosions/sfx_exp_medium2.wav"),
preload("res://assets/sounds/explosions/sfx_exp_medium3.wav")
,preload("res://assets/sounds/explosions/sfx_exp_medium4.wav")
,preload("res://assets/sounds/explosions/sfx_exp_medium5.wav")
,preload("res://assets/sounds/explosions/sfx_exp_medium6.wav")
,preload("res://assets/sounds/explosions/sfx_exp_medium7.wav")
,preload("res://assets/sounds/explosions/sfx_exp_medium8.wav")
,preload("res://assets/sounds/explosions/sfx_exp_medium9.wav")
,preload("res://assets/sounds/explosions/sfx_exp_medium10.wav")
,preload("res://assets/sounds/explosions/sfx_exp_medium11.wav")
,preload("res://assets/sounds/explosions/sfx_exp_medium12.wav")
,preload("res://assets/sounds/explosions/sfx_exp_medium13.wav")
]

const BOOM: String = "boom"
const EXPLODE: String = "explode"

#variables
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


#class variables
var _anim_name: String = EXPLODE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.animation = _anim_name
	animated_sprite_2d.play()
	SpaceUtils.play_random_sound2D(sound, EXPLOSION_SOUNDS)

func setup(anim_name: String) -> void: 
	_anim_name = anim_name


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
