extends BaseSpawner

const SHEEP_SCENE := preload("SheepFodder.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	super()


func create_entity() -> BaseNPC:
	return SHEEP_SCENE.instantiate()