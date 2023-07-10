extends Node2D


var enemy = preload("res://characters/enemy.tscn")
var score = 0
var round_running = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD/GameOver.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_game():
	score = 0
	$HUD.score_changed(score)
	$MobTimer.start()
	$HUD/Start.hide()
	$HUD/Quit.hide()

func _on_mob_timer_timeout():
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress = randi()
	
	var enemy_instance = enemy.instantiate()
	
	enemy_instance.position = mob_spawn_location.position
	enemy_instance.player_position = get_node("Player").position
	enemy_instance.connect("enemy_death", _on_enemy_enemy_death)
	
	call_deferred("add_child", enemy_instance)

func _on_enemy_enemy_death():
	score += 10
	$HUD.score_changed(score)

func _on_player_change_position(position):
	get_tree().call_group("enemies", "change_direction", position)


func _on_player_player_death():
	$MobTimer.stop()
	$HUD/Start.show()
	$HUD/Quit.show()
	$HUD/GameOver.show()
	$Player.queue_free()
	get_tree().call_group("enemies", "queue_free")
	
