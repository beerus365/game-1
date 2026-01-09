extends Area2D

@export var speed := 500
var direction := 1 # 1 = right & -1 = left

func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	queue_free()
