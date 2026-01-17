extends CharacterBody2D

@export var SPEED = 50
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var player_chase = false
var player = null

func _physics_process(delta: float) -> void:	
	if player_chase and player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * SPEED
		
		# Animation Handler
		var dir_x : float = player.global_position.x - global_position.x
		if dir_x > 0:
			animated_sprite.flip_h = false
		elif dir_x < 0:
			animated_sprite.flip_h = true
			
		if velocity.length() > 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")
		
	move_and_slide()

func _on_detect_body_entered(body: Node2D) -> void:
	if body is Player:
		print("hello", body.name)
		player = body
		player_chase = true

func _on_detect_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
		player_chase = false
	
