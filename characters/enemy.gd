extends CharacterBody2D

var enemy_speed = 100
var enemy_health = 100
var enemy_damage = 10
var player_position = Vector2.ZERO

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
		queue_free()
		emit_signal("enemy_death")
	
	move_and_slide()

func change_direction(direction):
	self.player_position = direction

func _on_area_2d_body_entered(body):
	if body.get_groups().has('projectiles'):
		enemy_health -= body.bullet_damage
		body.queue_free()
