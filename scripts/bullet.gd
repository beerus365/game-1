extends Area2D

@export var speed := 450
@onready var animated_sprite: AnimatedSprite2D = $AnimatableBody2D/AnimatedSprite2D

var direction := 1 # 1 = right & -1 = left

func _ready() -> void:
	# Change bullet size
	animated_sprite.scale = Vector2(0.8, 0.8)
	
	# Flips bullet sprite
	if direction == -1:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false	

func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	
	animated_sprite.play("hit_effect")
	
	await animated_sprite.animation_finished
	queue_free()
	
