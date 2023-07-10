extends Node2D

const STATE_GAME_OVER = "STATE_GAME_OVER"
const STATE_GAME_RUNNING = "STATE_GAME_RUNNING"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.hud = self
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_hud_state(state):
	if state == STATE_GAME_OVER:
		$Start.show()
		$Quit.show()
		$GameOver.show()
	elif state == STATE_GAME_RUNNING:
		$Start.hide()
		$Quit.hide()
		$GameOver.hide()

func change_score(score):
	$Score.text = str(score)

func change_health(health):
	if health <= 0:
		health = 0
	$HealthValue.text = str(health)

func _on_quit_pressed():
	get_tree().quit()

func _on_start_pressed():
	Global.main.start_game()
