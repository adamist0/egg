extends Node2D


var enemy = preload("res://characters/enemy.tscn")
var score = 0
var round_running = false
var xp = preload("res://items/xp.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.main = self
	$HUD/GameOver.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_game():
	score = 0
	round_running = true
	$HUD.change_score(score)
	$HUD.set_hud_state(Global.hud.STATE_GAME_RUNNING)
	$Player.start($PlayerSpawn.position)
	$MobTimer.start()

func _on_mob_timer_timeout():
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress = randi()
	
	var enemy_instance = enemy.instantiate()
	
	enemy_instance.position = mob_spawn_location.position
	enemy_instance.player_position = $Player.position
	enemy_instance.connect("enemy_death", _on_enemy_enemy_death)
	
	call_deferred("add_child", enemy_instance)

func _on_enemy_enemy_death(position):
	spawn_xp(position)

func _on_player_change_position(position):
	$Player/Gun.player_position = position
	get_tree().call_group("enemies", "change_direction", position)
	
func spawn_xp(spawn_position):
	var xp_instance = xp.instantiate()
	xp_instance.position = spawn_position
	add_child(xp_instance)

func _on_player_player_death():
	$MobTimer.stop()
	$HUD.set_hud_state(Global.hud.STATE_GAME_OVER)
	$Player.hide()
	$Player.active = false
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("xps", "queue_free")

func _on_player_player_got_xp():
	score += 10
	Global.hud.change_score(score)
