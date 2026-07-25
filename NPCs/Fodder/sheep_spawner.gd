extends BaseSpawner

const SHEEP_SCENE := preload("res://NPCs/Fodder/SheepFodder.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	super()


func create_entity() -> BaseNPC:
	var sheep: SheepFodder = SHEEP_SCENE.instantiate()

	return sheep