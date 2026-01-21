extends CanvasLayer
class_name UI

@onready var health_bar: ProgressBar = $Health/Health_Bar
@onready var mana_bar: ProgressBar = $Mana/Mana_Bar
@onready var mana_timer: Timer = $Mana/ManaTimer
@onready var health_timer: Timer = $Health/HealthTimer
@onready var player = $"../Player"
@onready var goblin = $"../Goblin"

func _ready() -> void:
	mana_bar.max_value = player.MAX_MANA
	health_bar.value = player.MAX_HEALTH
	
	update_mana()
	update_health()

# Mana and health handler
func update_mana():
	mana_bar.value = player.mana
	mana_bar.queue_redraw()
	print("Mana:", player.mana, "Bar value:", mana_bar.value)
	
func update_health():
	health_bar.value = player.health
	
func _on_timer_timeout() -> void:
	
	# For mana regenaration
	player.mana += player.MANA_REGEN
	player.mana = clamp(player.mana, 0, player.MAX_MANA)
	mana_bar.value = player.mana
	
func _on_health_timer_timeout() -> void:
	# For health regeneration
	player.health += player.HEALTH_REGEN
	player.health = clamp(player.health, 0, player.MAX_HEALTH)
	health_bar.value = player.health
