extends BaseSpawner

const WOLF_SCENE := preload("wolf.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	super()

func create_entity() -> BaseNPC:
	return WOLF_SCENE.instantiate()
