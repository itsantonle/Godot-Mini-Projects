extends Node2D

const OBJECT_SCENES: Dictionary[Constants.ObjectType, PackedScene]= {
	Constants.ObjectType.BULLET_PLAYER : preload("res://Scenes/Bullets/PlayerBullet.tscn"), 
	Constants.ObjectType.BULLET_ENEMy: preload("res://Scenes/Bullets/EnemyBullet.tscn"), 
	Constants.ObjectType.EXPLOSION: preload("res://Scenes/Explosion/Explosion.tscn"),
	Constants.ObjectType.PICKUP: preload("res://Scenes/FruitPickup/FruitPickup.tscn")
		 }

func _enter_tree() -> void:
	SignalHub.on_create_bullet.connect(on_create_bullet)
	SignalHub.on_create_object.connect(on_create_object)
	
func on_create_bullet(pos: Vector2, dir: Vector2, speed: float, ob_type: Constants.ObjectType) ->void: 
		if !OBJECT_SCENES.has(ob_type): 
			return 
			
		var nb: Bullet = OBJECT_SCENES[ob_type].instantiate()
		nb.setup(pos,dir, speed)
		# invoke call_deffered to those that may not sync poperly
		call_deferred("add_child", nb)
		
func on_create_object(pos: Vector2, ob_type: Constants.ObjectType) -> void: 
	if !OBJECT_SCENES.has(ob_type): 
		return 
	var obj: Node2D= OBJECT_SCENES[ob_type].instantiate()
	obj.global_position = pos
	call_deferred("add_child", obj)
