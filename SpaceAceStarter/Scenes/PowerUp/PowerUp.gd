extends Projectile
class_name PowerUp

enum PowerUpType {Health, Shield}
#constants
const SPEED: float = 80.0
const TEXTURES: Dictionary = {
	PowerUpType.Health : preload("res://assets/misc/powerupGreen_bolt.png"),
	PowerUpType.Shield: preload("res://assets/misc/shield_gold.png") }


#variables
@onready var sprite_2d: Sprite2D = $Sprite2D


#getters and setters
var power_up_type: PowerUpType = PowerUpType.Shield:
	get: return power_up_type
	

func _ready() -> void:
	sprite_2d.texture = TEXTURES[power_up_type]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += SPEED * delta * Vector2.DOWN
	

func pick_random_powerup() -> void: 
	# POWER_UP.PowerUpType.values.pick_random()
	var keys = TEXTURES.keys()
	var random_key = keys[randi() % keys.size()]
	power_up_type = random_key
