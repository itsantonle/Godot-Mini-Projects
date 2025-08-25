extends Node

signal on_played_died
signal on_player_hit(v: int)
signal on_score_updated(v: int)
signal on_create_explosion(pos: Vector2, anim_name: String)
signal on_create_powerup(pos: Vector2, power_up_type: PowerUp.PowerUpType)
signal on_create_random_powerup(pos: Vector2)
signal on_create_bullet(start_pos:Vector2, dir:Vector2, spd: float, type: BulletBase.BulletType)
signal on_player_hits_power_up(type: PowerUp.PowerUpType)
signal on_player_health_bonus(v: int )

func emit_on_player_died() -> void: 
	on_played_died.emit()
	
func emit_on_player_hit(v: int) -> void:
	on_player_hit.emit(v)


func emit_on_score_updated(v: int):
	on_score_updated.emit(v)
	
func emit_on_create_explosion(pos: Vector2, anim_name: String): 
	on_create_explosion.emit(pos, anim_name)

func emit_on_create_powerup(pos: Vector2, power_up_type: PowerUp.PowerUpType) -> void: 
	on_create_powerup.emit(pos, power_up_type)

func emit_on_create_random_powerup(pos: Vector2): 
	on_create_random_powerup.emit(pos)

func emit_on_create_bullet(start_pos: Vector2, dir:Vector2, spd: float, type: BulletBase.BulletType): 
	on_create_bullet.emit(start_pos,dir, spd, type)
	
func emit_on_player_hits_power_up(type: PowerUp.PowerUpType): 
	on_player_hits_power_up.emit(type)

func  emit_on_player_health_bonus(v: int ):
	on_player_health_bonus.emit(v)
