extends BasePickup

enum UpgradeEffect {MAX_HEALTH, MAX_ARMOUR, DAMAGE_INCREASE}

@export var upgrade_effect: UpgradeEffect

@export var effect_value: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
