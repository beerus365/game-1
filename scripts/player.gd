extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -275.0

@onready var animated_sprite = $AnimatedSprite2D
@export var jump_effect: PackedScene

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		_play_jump_effect()

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
	
func _play_jump_effect():

	var fx = jump_effect.instantiate()
	fx.global_position = global_position + Vector2(0, 0)
	
	get_parent().add_child(fx)
	
	fx.play("jump_effect")
	await fx.animation_finished
	fx.queue_free()

# Attack for player
@export var attacking = false
@export var bullet_scene: PackedScene
@onready var gun_point = $GunPoint
		
func _attack():
	attacking = true
	animated_sprite.play("shoot")
	
	fire()
	
	await animated_sprite.animation_finished
	attacking = false
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		_attack()
		
# Bullet processd l
func _bullet_physics(delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("attack"):
		fire()
		
func fire():
	var bullet=bullet_scene.instantiate()
	
	# Set global position
	bullet.global_position = gun_point.global_position
	
	# Set direction on where the player is facing
	if animated_sprite.flip_h:
		bullet.direction = -1
	else:
		bullet.direction = 1
		
	get_parent().add_child(bullet)
	
