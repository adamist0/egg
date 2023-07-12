extends Area2D

var player_position = Vector2.ZERO;
var bullet = preload("res://items/bullet.tscn")
var bullet_speed = 2000
var cooldown = false

func _ready():
	pass

func _process(delta):
	if Global.main.game_paused == true:
		return

	var mouse_position = get_global_mouse_position();
	look_at(mouse_position)
	var a = mouse_position - player_position
	if a.x < 0:
		$AnimatedSprite2D.flip_v = true
	else:
		$AnimatedSprite2D.flip_v = false

func fire(fire_direction):
	if !cooldown && !Global.main.game_paused:
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = $Marker2D.position
		
		var direction = fire_direction - self.position
		bullet_instance.look_at(fire_direction.rotated(-rotation))
		
		bullet_instance.apply_central_impulse(fire_direction * bullet_speed)

		call_deferred("add_child", bullet_instance)
		cooldown = true

func _on_fire_timer_timeout():
	cooldown = false
