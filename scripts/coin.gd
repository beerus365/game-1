extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	print("+1 coin")
	animated_sprite.play("pick_up")
	
	await animated_sprite.animation_finished
	queue_free()
	
	
	
