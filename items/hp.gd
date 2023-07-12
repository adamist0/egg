extends CharacterBody2D


const SPEED = 20.0

var follow_player = false
var player_body = null

func _physics_process(delta):
	if follow_player:
		velocity += player_body.position - position

	move_and_slide()

func _on_detect_player_body_entered(body):
	if body.name == "Player":
		follow_player = true
		player_body = body


func _on_detect_player_body_exited(body):
	if body.name == "Player":
		follow_player = false
