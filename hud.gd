extends Node2D

const STATE_GAME_OVER = "STATE_GAME_OVER"
const STATE_GAME_RUNNING = "STATE_GAME_RUNNING"
const STATE_GAME_PAUSED = "STATE_GAME_PAUSED"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.hud = self
	$Paused.hide()
	$GameOver.hide()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_hud_state(state):
	if state == STATE_GAME_OVER:
		$Start.show()
		$Quit.show()
		$GameOver.show()
		$Paused.hide()
		$GameTitle.hide()
	elif state == STATE_GAME_RUNNING:
		$Start.hide()
		$Quit.hide()
		$GameOver.hide()
		$Paused.hide()
		$GameTitle.hide()
	elif state == STATE_GAME_PAUSED:
		$Paused.show()
		$GameTitle.hide()
		

func change_score(score):
	$Score.text = str(score)

func change_health(health):
	if health <= 0:
		health = 0
	$Health/HealthValue.text = str(health)
	$Health/TextureProgressBar.set_value_no_signal(health)

func _on_quit_pressed():
	get_tree().quit()

func _on_start_pressed():
	Global.main.start_game()
