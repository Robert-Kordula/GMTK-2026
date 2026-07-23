extends CanvasLayer

@onready var health_container:FlowContainer = $HealthContainer

var hearts: Array[TextureRect] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	hearts = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
