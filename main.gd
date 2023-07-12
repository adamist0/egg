extends Node2D


var enemy = preload("res://characters/enemy.tscn")
var score = 0
var round_running = false
var game_paused = false

func _ready():
	Global.main = self
	Global.player.hide()
	$Walls.hide()

func _process(delta):
	if Input.is_action_just_released("pause") && round_running:
		if get_tree().paused:
			Global.hud.set_hud_state(Global.hud.STATE_GAME_RUNNING)
			get_tree().paused = false
		else:
			Global.hud.set_hud_state(Global.hud.STATE_GAME_PAUSED)
			get_tree().paused = true

func start_game():
	score = 0
	round_running = true
	Global.hud.change_score(score)
	Global.hud.set_hud_state(Global.hud.STATE_GAME_RUNNING)
	$Player.start($PlayerSpawn.position)
	$Walls.show()
#	$MobTimer.start()

func _on_mob_timer_timeout():
	var mob_spawn_rect_size = $MobSpawnRect.get_size()
	var mob_spawn_rect_position = $MobSpawnRect.position

	var mob_spawn_position = Vector2(
		randf_range(mob_spawn_rect_position.x, mob_spawn_rect_position.x + mob_spawn_rect_size.x),
		randf_range(mob_spawn_rect_position.y, mob_spawn_rect_position.y + mob_spawn_rect_size.y)
	)
	
	var enemy_instance = enemy.instantiate()
	
	enemy_instance.position = mob_spawn_position
	enemy_instance.player_position = $Player.position
	
	call_deferred("add_child", enemy_instance)

func _on_player_change_position(position):
	$Player/Gun.player_position = position
	get_tree().call_group("enemies", "change_direction", position)

func _on_player_player_death():
	$MobTimer.stop()
	Global.hud.set_hud_state(Global.hud.STATE_GAME_OVER)
	$Player.hide()
	$Walls.hide()
	$Player.active = false
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("xps", "queue_free")

func player_got_xp():
	score += 10
	Global.hud.change_score(score)
	
func player_got_hp():
	var health = min(Global.player.player_health + 20, 100)
	Global.player.player_health = health
	Global.hud.change_health(health)
