extends Node2D

const EXPLOSION = preload("res://Scenes/Explosion/Explosion.tscn")
const POWER_UP = preload("res://Scenes/PowerUp/PowerUp.tscn")

const ADD_OBJECT: String = "add_object"

const BULLETS: Dictionary = {
	BulletBase.BulletType.Player : preload("res://Scenes/BulletBase/BulletPlayer.tscn"), 
	BulletBase.BulletType.Enemy: preload("res://Scenes/BulletBase/BulletEnemy.tscn"), 
	BulletBase.BulletType.Bomb: preload("res://Scenes/BulletBase/BulletBomb.tscn")
}

func _enter_tree() -> void:
	SignalHub.on_create_explosion.connect(create_explosion)
	SignalHub.on_create_powerup.connect(on_create_powerup)
	SignalHub.on_create_random_powerup.connect(on_create_random_powerup)
	SignalHub.on_create_bullet.connect(on_create_bullet)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

#region create functions
func add_object(obj: Node, pos: Vector2) -> void:
	add_child(obj)
	obj.global_position = pos
	
	
func create_explosion(pos: Vector2, anim_name: String):
	var explosion: Explosion = EXPLOSION.instantiate()
	call_deferred(ADD_OBJECT, explosion, pos)
	explosion.setup(anim_name)
	
func on_create_powerup(pos: Vector2, power_up_type: PowerUp.PowerUpType) -> void: 
	var powerup: PowerUp = POWER_UP.instantiate()
	powerup.power_up_type = power_up_type
	call_deferred(ADD_OBJECT, powerup, pos)
	
func on_create_random_powerup(pos: Vector2): 
	var powerup: PowerUp = POWER_UP.instantiate()
	powerup.pick_random_powerup()
	call_deferred(ADD_OBJECT, powerup, pos)

func on_create_bullet(start_pos: Vector2, dir:Vector2, spd: float, type: BulletBase.BulletType): 
	if !BULLETS[type]: 
		return 
	var bullet: BulletBase = BULLETS[type].instantiate()
	bullet.setup(dir, spd)
	call_deferred(ADD_OBJECT, bullet, start_pos)
	
	
	
#endregion
