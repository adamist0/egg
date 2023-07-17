extends CharacterBody2D

var move_speed: float = 400.0
var player_health: int = 100
var player_is_touching_enemy:bool = false
var active: bool = false
var is_autoshoot_active: bool = false

signal change_position
signal change_health
signal player_death

func _ready():
	Global.player = self
	Global.hud.change_health(player_health)

func start(new_position):
	position = new_position
	player_health = 100
	Global.hud.change_health(player_health)
	active = true
	emit_signal("change_position", position)
	show()

func _physics_process(delta):
	var direction = Vector2.ZERO
	var mouse_position = get_global_mouse_position()
	
	if Input.is_action_pressed("player_down"):
		direction.y += 1
	elif Input.is_action_pressed("player_up"):
		direction.y -= 1
		
	if Input.is_action_pressed("player_left"):
		direction.x -= 1
	elif Input.is_action_pressed("player_right"):
		direction.x += 1
		$AnimatedSprite2D.flip_h = false;
	
	if direction.x == 0 && direction.y == 0:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.animation = "eyes"
		var p = global_position - mouse_position
		if (p.y > 200):
			$AnimatedSprite2D.set_frame_and_progress(2, 0)
		elif (p.y < -200):
			$AnimatedSprite2D.set_frame_and_progress(1, 0)
		else:
			$AnimatedSprite2D.set_frame_and_progress(0, 0)
	
	if Input.is_action_just_released("auto_shoot"):
		is_autoshoot_active = !is_autoshoot_active
	
	if Input.is_action_just_released("fire") || is_autoshoot_active:
		var fire_direction = global_position.direction_to(mouse_position)
		if active:
			$Gun.fire(fire_direction)
		
	if player_health <= 0:
		emit_signal("player_death")
		hide()
		
	var lookPosition = self.position - mouse_position
	
	if lookPosition.x >= 0:
		$AnimatedSprite2D.flip_h = true;
	else:
		$AnimatedSprite2D.flip_h = false;

	velocity = direction.normalized() * move_speed * delta
	
	emit_signal("change_position", self.position)

	if velocity.x == 0 && velocity.y == 0:
		$AnimationPlayer.stop()
	else:
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("doink")
	move_and_collide(velocity)

func _on_damage_timer_timeout():
	if player_is_touching_enemy:
		player_health -= 20
		Global.hud.change_health(player_health)

func _on_hitbox_area_entered(area):
	if area.get_groups().has("xps"):
		Global.main.player_got_xp()
		area.get_parent().taken()
	if area.get_groups().has("hps"):
		Global.main.player_got_hp()
		area.queue_free()

func _on_hitbox_body_entered(body):
	if body.get_groups().has("enemies"):
		player_is_touching_enemy = true


func _on_hitbox_body_exited(body):
	if body.get_groups().has("enemies"):
		player_is_touching_enemy = false
