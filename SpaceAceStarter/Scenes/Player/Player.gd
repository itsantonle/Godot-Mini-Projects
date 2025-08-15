extends Area2D


class_name Player



const GROUP_NAME: String = "Player"




@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shield: Shield = $Shield
@export var bullet_speed: float = 350.0
@export var health_bonus: int = 25
@export var speed: float = 250.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _enter_tree() -> void:
	add_to_group(GROUP_NAME)
	print('added player')
	

func keep_off_screen() -> void:
	var visible_rect = get_viewport().get_visible_rect()
	var pos = global_position  
	
	#clamp position
	pos.x = clamp(pos.x, visible_rect.position.x, visible_rect.position.x + visible_rect.size.x)
	pos.y = clamp(pos.y, visible_rect.position.y, visible_rect.position.y + visible_rect.size.y)
	global_position = pos 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input = get_input()
	shoot()
	keep_off_screen()
	global_position += input *delta * speed
	


# makes a vector two of x and y - assigns -1 to the left side and positive to the right
func get_input() -> Vector2: 
	var v = Vector2(Input.get_axis("left", "right"), 
	Input.get_axis("up", "down")
	)
	if v.x != 0: 
		animation_player.play("turn")
		sprite_2d.flip_h = true if v.x < 0 else false
	else: 
		animation_player.play("fly")
		
	return v.normalized()
	
func shoot() -> void: 
	if Input.is_action_just_pressed("shoot"): 
		SignalHub.emit_on_create_bullet(global_position, Vector2.UP, bullet_speed, BulletBase.BulletType.Player)
	
func _on_area_entered(area: Area2D) -> void:
	print("area entered" ,  area)
	if area is PowerUp: 
		match area.power_up_type: 
			PowerUp.PowerUpType.Shield: 
				SignalHub.emit_on_player_hits_power_up(PowerUp.PowerUpType.Shield)
			PowerUp.PowerUpType.Health: 
				SignalHub.emit_on_player_hits_power_up(PowerUp.PowerUpType.Health)
				SignalHub.emit_on_player_health_bonus(health_bonus)
		area.set_process(false)
		area.queue_free()
		
	if area is BulletBase : 
		SignalHub.emit_on_player_hit(area.get_damage())
		area.queue_free()
	
	
			
			
		
	
		
