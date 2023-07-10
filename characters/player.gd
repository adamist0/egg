extends CharacterBody2D


var move_speed = 400
var bullet_speed = 2000
var player_health = 100
var player_is_touching_enemy = false
var bullet = preload("res://items/bullet.tscn")

signal change_position
signal change_health
signal player_death

func _ready():
	emit_signal("change_health", player_health)

func _physics_process(delta):
	var direction = Vector2.ZERO
	var mouse_position = get_viewport().get_mouse_position()
	
	if Input.is_action_pressed("player_down"):
		direction.y += 1
	elif Input.is_action_pressed("player_up"):
		direction.y -= 1
		
	if Input.is_action_pressed("player_left"):
		direction.x -= 1
	elif Input.is_action_pressed("player_right"):
		direction.x += 1
		$AnimatedSprite2D.flip_h = false;
		
	if Input.is_action_just_pressed("fire"):
		var fire_direction = self.global_position.direction_to(mouse_position)
		fire(fire_direction)
		
	if player_health <= 0:
		emit_signal("player_death")
		
	var lookPosition = self.position - mouse_position
	
	if lookPosition.x >= 0:
		$AnimatedSprite2D.flip_h = true;
	else:
		$AnimatedSprite2D.flip_h = false;
		
	velocity = direction.normalized() * move_speed * delta
	
	emit_signal("change_position", self.position)

	move_and_collide(velocity)

func fire(fire_direction):
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = get_position_delta()
	
	var direction = fire_direction - self.position
	bullet_instance.look_at(fire_direction)
	
	bullet_instance.apply_central_impulse(fire_direction * bullet_speed)

	get_tree().get_root().call_deferred("add_child", bullet_instance)

func _on_damage_timer_timeout():
	if player_is_touching_enemy:
		player_health -= 20
		emit_signal("change_health", player_health)

func _on_area_2d_body_entered(body):
	if body.get_groups().has("enemies"):
		player_is_touching_enemy = true


func _on_area_2d_body_exited(body):
	if body.get_groups().has("enemies"):
		player_is_touching_enemy = false
