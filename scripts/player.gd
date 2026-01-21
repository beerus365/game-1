extends CharacterBody2D
class_name Player

const SPEED = 100.0
const JUMP_VELOCITY = -275.0

var health := 100
var mana := 100
var MAX_HEALTH = 100
var MAX_MANA = 100
var HEALTH_REGEN = 20
var MANA_REGEN = 2
var MANA_COST = 20

@onready var animated_sprite = $AnimatedSprite2D
@onready var ui = $"../UI"
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
		
		if velocity.y < 0 and not is_on_floor():
			animated_sprite.play("jump_down")

			
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
	
func use_mana():
	mana -= MANA_COST
	mana = clamp(mana, 0, MAX_MANA)
	
func _attempt_attack():
	if mana >= MANA_COST:
		use_mana()
		_attack()
	else:
		print("Not enough mana")
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		_attempt_attack()
		
func fire():
	if bullet_scene == null:
		print("No bullet")
		return
	
	var bullet=bullet_scene.instantiate()
	
	# Set global position
	if animated_sprite.flip_h:
		gun_point.position.x = -20
	else:
		gun_point.position.x = 20
	
	bullet.global_position = gun_point.global_position
	get_tree().current_scene.add_child(bullet)
	
	# Set direction on where the player is facing
	if animated_sprite.flip_h:
		bullet.setup(-1)
	else:
		bullet.setup(1)
		
# Damage taken of player from enemies
func take_damage(amount: int) -> void:
	health -= amount
	health = clamp(health, 0, MAX_HEALTH)
	
	ui.update_health()
	print("Player health: ", health)
	
	

		
		
	
