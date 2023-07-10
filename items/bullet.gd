extends RigidBody2D

var bullet_damage = 50

func _ready():
	self.lock_rotation = true

func _physics_process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
