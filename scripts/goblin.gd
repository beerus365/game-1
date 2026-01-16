extends CharacterBody2D

@export var SPEED = 50
var player_chase = false
var player = null

func _physics_process(delta: float) -> void:
	if player_chase and player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func _on_detect_body_entered(body):
	if body.is_in_group("Player"):
		print("hello")
		player = body
		player_chase = true

func _on_detect_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		player_chase = false
	
