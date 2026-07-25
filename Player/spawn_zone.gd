extends Area2D

@export var vertical_margin: float = 100
@export var horizontal_margin: float = 100

@onready var viewport_size: Vector2 = get_viewport_rect().size / get_viewport().get_camera_2d().zoom
@onready var vertical_adjustment =  Vector2(0, (viewport_size.y / 2) + vertical_margin / 2)
@onready var horizontal_adjustment = Vector2(viewport_size.x / 2 + horizontal_margin / 2, 0)
@onready var vertical_box_size = Vector2( viewport_size.x + horizontal_margin * 2, vertical_margin )
@onready var horizontal_box_size = Vector2(horizontal_margin, viewport_size.y)
@onready var spawn_zone_top: CollisionShape2D = $Top
@onready var spawn_zone_bottom: CollisionShape2D = $Bottom
@onready var spawn_zone_left: CollisionShape2D = $Left
@onready var spawn_zone_right: CollisionShape2D = $Right


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_zone_top.shape.size = vertical_box_size
	spawn_zone_top.position -= vertical_adjustment
	spawn_zone_bottom.shape.size = vertical_box_size
	spawn_zone_bottom.position += vertical_adjustment

	spawn_zone_left.shape.size = horizontal_box_size
	spawn_zone_left.position -= horizontal_adjustment
	spawn_zone_right.shape.size = horizontal_box_size
	spawn_zone_right.position += horizontal_adjustment
