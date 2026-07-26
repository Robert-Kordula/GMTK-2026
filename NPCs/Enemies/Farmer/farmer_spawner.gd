extends BaseSpawner

const FARMER_SCENE := preload("Farmer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	super()

func create_entity() -> BaseNPC:
	return FARMER_SCENE.instantiate()