extends Projectile

class_name BulletBase

enum BulletType {Player, Enemy, Bomb}



#class variables 
var _direction: Vector2  = Vector2.DOWN
var _speed: float  = 400


#func _ready() -> void:
	#_player_ref = get_tree().get_first_node_in_group(Player.GROUP_NAME)
	#if !_player_ref: 
		#set_process(false)
		#queue_free()
		#print('no player')

func _process(delta: float) -> void:
	
	position += delta * _direction * _speed
	#rotation = global_position.angle_to(_player_ref.global_position)
	
func setup(dir: Vector2, sp: float): 
	_direction = dir 
	_speed = sp 

func blow_up() -> void: 
	SignalHub.emit_on_create_explosion(global_position, Explosion.EXPLODE)
	super()
