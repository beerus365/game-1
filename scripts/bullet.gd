extends Area2D

@export var speed := 450
@export var bullet_scene: PackedScene
@onready var animated_sprite: AnimatedSprite2D = $AnimatableBody2D/AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var direction := 1 # 1 = right & -1 = left

func setup(dir: int):
	direction = dir

	animated_sprite.flip_h = (dir == -1)
	
	# Change bullet size
	animated_sprite.scale = Vector2(0.8, 0.8)
		
func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta
	
func _on_body_entered(body: Node) -> void:
	
	set_physics_process(false)
	collision.set_deferred("disabled", true)
	
	animated_sprite.play("hit_effect")
	await animated_sprite.animation_finished
	queue_free()
	
