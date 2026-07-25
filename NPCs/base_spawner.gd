class_name BaseSpawner
extends Area2D

@export var max_entities: int = 100

@onready var spawn_range: CollisionShape2D = $SpawnRange;

var entities: Array[BaseNPC] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func try_spawn():
	if entities.size() >= max_entities:
		return
	
	var entity = create_entity()
	register_entity(entity)


func register_entity(entity: BaseNPC) -> void:
	entities.append(entity)
	add_child(entity)

	entity.global_position = get_random_position()
	entity.tree_exiting.connect(_on_entity_removed.bind(entity))


func create_entity() -> BaseNPC:
	var message := "%s must override create_entity()" % get_class()
	push_error(message)
	assert(false, message)
	return null


func _on_entity_removed(entity: BaseNPC) -> void:
	entities.erase(entity)


func get_random_position() -> Vector2:
	var range_in_pixels = (spawn_range.shape as CircleShape2D).radius
	var angle = randf_range(0.0, TAU)
	var distance = range_in_pixels * sqrt(randf())

	return global_position + Vector2.from_angle(angle) * distance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	try_spawn()
