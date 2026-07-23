class_name Hud 
extends CanvasLayer

@onready var hearts_container:FlowContainer = $HeartsContainer

@onready var heart_template: TextureRect = $HeartsContainer/HeartTemplate
@onready var empty_heart_template: TextureRect = $HeartsContainer/EmptyHeartTemplate


# Called when the node enters the scene tree for the first time.
func _ready():
	heart_template.hide()
	empty_heart_template.hide()

func connect_player(player: Player):
	player.change_to_health.connect(update_health)
	update_health(player.health, player.max_health)

func update_health(currentHealth: int, max_health: int):
	# Reset $HeartsContainer before re-rendering hearts
	for child in $HeartsContainer.get_children():
		if child != heart_template || child != empty_heart_template:
			child.queue_free()
	
	for i in max_health:
		if i < currentHealth:
			var heart:= heart_template.duplicate()
			heart.show()
			$HeartsContainer.add_child(heart)
		else:
			var empty_heart:= empty_heart_template.duplicate()
			empty_heart.show()
			$HeartsContainer.add_child(empty_heart)
