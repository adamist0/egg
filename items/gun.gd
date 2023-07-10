extends Area2D

var player_position = Vector2.ZERO;
var bullet = preload("res://items/bullet.tscn")
var bullet_speed = 2000
var cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_viewport().get_mouse_position();
	look_at(mouse_position)
	var a = mouse_position - player_position
	if a.x < 0:
		$AnimatedSprite2D.flip_v = true
#		position = Vector2(0, 20)
	else:
		$AnimatedSprite2D.flip_v = false
#		position = Vector2(0, 0)

func fire(fire_direction):
	if !cooldown:
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = $Marker2D.position
		
		var direction = fire_direction - self.position
		bullet_instance.look_at(fire_direction.rotated(-rotation))
		
		bullet_instance.apply_central_impulse(fire_direction * bullet_speed)

	#	get_tree().get_root().call_deferred("add_child", bullet_instance)
		call_deferred("add_child", bullet_instance)
		cooldown = true


func _on_fire_timer_timeout():
	cooldown = false
