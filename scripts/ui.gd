extends CanvasLayer

@onready var health_bar: ProgressBar = $Health/Health_Bar
@onready var mana_bar: ProgressBar = $Mana/Mana_Bar
const Player = preload("uid://crwyjhpsaidfb")

var mana := 100 
var health := 100 
const MAX_HEALTH = 100
const MAX_MANA = 100
const MANA_COST = 20
const HEALTH_REGEN = 20

func _ready() -> void:
	mana_bar.max_value = MAX_MANA
	health_bar.value = MAX_HEALTH
	
	mana_bar.value = mana
	health_bar.value = health

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		if mana >= MANA_COST:
			use_mana()
		else:
			print("Not enough mana")
	
		

# Mana handler
func use_mana():
	mana -= MANA_COST
	mana = clamp(mana, 0, MAX_MANA)
	mana_bar.value = mana
	
