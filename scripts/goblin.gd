extends CharacterBody2D
class_name Goblin

const SPEED = 50
const JUMP_VELOCITY = -275
const DAMAGE = 10
const DAMAGE_INTERVAL = 0.5
var damage_cooldown := 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_right: RayCast2D = $raycast_right
@onready var ray_left: RayCast2D = $raycast_left
@onready var health_damage = null

var player: Node2D = null
var player_chase := false

func _physics_process(delta: float) -> void:
	if damage_cooldown > 0:
		damage_cooldown -= delta
	
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	if player_chase and player != null:
		attack_player(player)
		
		if attacking:
			velocity.x = 0
		else:
			var dir = sign(player.global_position.x - global_position.x)
			velocity.x = dir * SPEED
			
			# Flip sprite
			animated_sprite.flip_h = dir < 0
			
			# Jump abstacles
			if is_on_floor() and obstacle_in_direction(dir):
				velocity.y = JUMP_VELOCITY
		
		if not attacking:
			animated_sprite.play("run")
	else:
		velocity.x = 0
		animated_sprite.play("idle")

	move_and_slide()


func obstacle_in_direction(dir: int) -> bool:
	if dir > 0:
		return ray_right.is_colliding()
	elif dir < 0:
		return ray_left.is_colliding()
	return false

func _on_detect_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		player_chase = true

func _on_detect_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
		player_chase = false
		
# Attacking
var attacking := false
var can_damage := true

func hits_player(ray: RayCast2D) -> bool:
	if ray.is_colliding():
		var obj = ray.get_collider()

		if obj.is_in_group("Player"):
			return true

		if obj.get_parent() and obj.get_parent().is_in_group("Player"):
			return true

	return false
	
func attack_player(player: Player) -> void:
	if player == null:
		return

	if not (hits_player(ray_right) or hits_player(ray_left)):
		attacking = false
		return

	attacking = true
	animated_sprite.play("attack")

	if damage_cooldown > 0:
		return

	player.take_damage(DAMAGE)
	damage_cooldown = DAMAGE_INTERVAL
	

	
		
		
