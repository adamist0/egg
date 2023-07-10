extends Node2D

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func score_changed(score):
	$Score.text = str(score)

func _on_player_change_health(health):
	if health <= 0:
		health = 0
	$HealthValue.text = str(health)

func _on_quit_pressed():
	get_tree().quit()

func _on_start_pressed():
	emit_signal("start_game")
