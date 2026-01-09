extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -275.0

@onready var animated_sprite = $AnimatedSprite2D
@export var attacking = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handles player movements: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Flips the sprites
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# If attacking, do not override animations
	if attacking:
		move_and_slide()
		return
		
	# Play animations
	if not attacking:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")		
		else:
			animated_sprite.play("jump")		
			
	move_and_slide()

	
func _attack():
	attacking = true
	animated_sprite.play("shoot")
	
	await animated_sprite.animation_finished
	attacking = false
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		_attack()
		
# Bullet process
var bullet_path=preload("res://scenes/bullets.tscn")

func _bullet_physics(delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("attack"):
		fire()
		
func fire():
	var bullet=bullet_path.instantiate()
	
	bullet.dir = rotation
	bullet.pos = $Node2D.global_position
	bullet.rota=global_rotation
	get_parent().add_child(bullet)
	
