extends BaseSpawner

const SHEEP_SCENE := preload("SheepFodder.tscn")
const HEALTH_PICKUP_SCENE := preload("res://Items/Upgrades/health_pickup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	super()


func create_entity() -> BaseNPC:
	return SHEEP_SCENE.instantiate()

func register_entity(entity: BaseNPC) -> void:
	super.register_entity(entity)

	entity.died.connect(_on_sheep_died)

func _on_sheep_died(
	_entity: BaseNPC,
	death_position: Vector2
) -> void:
	var random = randf()
	if random >= 0.1:
		return

	var health_pickup := HEALTH_PICKUP_SCENE.instantiate() as BasePickup
	get_parent().call_deferred("add_child", health_pickup)
	health_pickup.global_position = death_position