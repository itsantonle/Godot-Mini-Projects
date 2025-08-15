extends Node2D


class_name Level 

#variables
@onready var object_maker: Node2D = $ObjectMaker
@onready var player: Player = $Player
@onready var marker_2d: Marker2D = $Marker2D


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"): 
		#SignalHub.emit_on_create_explosion(player.global_position, Explosion.EXPLODE)
		SignalHub.emit_on_create_powerup(player.global_position + Vector2(0, -80) , PowerUp.PowerUpType.Health)
		#SignalHub.emit_on_create_random_powerup(marker_2d.global_position)
		#SignalHub.emit_on_create_bullet(player.global_position, Vector2(1,-1).normalized(), 500, BulletBase.BulletType.Enemy)
		#SignalHub.emit_on_create_bullet(Vector2.ZERO, Vector2.DOWN, 500, BulletBase.BulletType.Bomb)
		#SignalHub.emit_on_player_hits_power_up(PowerUp.PowerUpType.Shield)
