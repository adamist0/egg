extends Area2D

var bullet = preload("res://items/bullet.tscn")
var bullet_speed = 2000
var cooldown = false

func _ready():
	pass

func _process(delta):
	var mouse_position = get_global_mouse_position();
	look_at(mouse_position)
	
	if Global.player.position.x > mouse_position.x:
		$AnimatedSprite2D.flip_v = true
	else:
		$AnimatedSprite2D.flip_v = false

func fire(fire_direction):
	if !cooldown:
		var bullet_instance = bullet.instantiate()
		
		if $AnimatedSprite2D.flip_v == true:
			bullet_instance.position = $MarkerLeft.position
		else:
			bullet_instance.position = $MarkerRight.position
		
		var direction = fire_direction - self.position
		bullet_instance.look_at(fire_direction.rotated(-rotation))
		
		bullet_instance.apply_central_impulse(fire_direction * bullet_speed)
		
		$AudioStreamPlayer2D.play()

		call_deferred("add_child", bullet_instance)
		cooldown = true

func _on_fire_timer_timeout():
	cooldown = false
