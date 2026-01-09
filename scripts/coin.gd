extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	
	animated_sprite.play("pick_up")
	print("+1 coin")
	
	await animated_sprite.animation_finished
	queue_free()
	
	
	
