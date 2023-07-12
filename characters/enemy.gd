extends CharacterBody2D

var enemy_speed = 100
var enemy_health = 100
var enemy_damage = 10
var player_position = Vector2.ZERO
var xp = preload("res://items/xp.tscn")
var hp = preload("res://items/hp.tscn")

signal enemy_death

func _physics_process(delta):
	var enemy_direction = self.position.direction_to(player_position)

	var velocity = Vector2(enemy_speed, 0)
	self.velocity = velocity.rotated(enemy_direction.angle())
	
	if enemy_direction.x >= 0:
		$AnimatedSprite2D.flip_h = false;
	else:
		$AnimatedSprite2D.flip_h = true;
	
	if enemy_health <= 0:
		await spawn_reward(self.position)
		queue_free()
	
	move_and_slide()

func spawn_reward(spawn_position):
	var randi = randi_range(0, 9)
	var reward_instance = null
	if randi == 0:
		reward_instance = hp.instantiate()
	else:
		reward_instance = xp.instantiate()
		
	reward_instance.position = spawn_position
	Global.main.add_child(reward_instance)

func change_direction(direction):
	self.player_position = direction

func _on_hitbox_body_entered(body):
	if body.get_groups().has('projectiles'):
		enemy_health -= body.bullet_damage
		body.queue_free()
