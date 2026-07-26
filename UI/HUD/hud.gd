class_name Hud
extends CanvasLayer

var label_text = "SCORE: %s"

@onready var hearts_container:FlowContainer = $Control/HeartsContainer
@onready var heart_template: TextureRect = $Control/HeartsContainer/HeartTemplate
@onready var empty_heart_template: TextureRect = $Control/HeartsContainer/EmptyHeartTemplate

@onready var armour_container:FlowContainer = $Control/ArmourContainer
@onready var armour_template: TextureRect = $Control/ArmourContainer/ArmourTemplate
@onready var empty_armour_template: TextureRect = $Control/ArmourContainer/EmptyArmourTemplate

@onready var score_label: Label = $Control/Score

# @onready var armour_container: FlowContainer = $

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	heart_template.hide()
	empty_heart_template.hide()
	armour_template.hide()
	empty_armour_template.hide()


func connect_player(player: Player):
	player.change_to_health.connect(update_health)
	update_health(player.health, player.max_health)
	player.change_to_armour.connect(update_armour)
	update_armour(player.armour, player.max_armour)
	player.killed_npc.connect(update_score)
	update_score(0)


func update_health(current_health: int, max_health: int):
	# Reset heart_container before re-rendering hearts
	for child in hearts_container.get_children():
		if child != heart_template and child != empty_heart_template:
			child.queue_free()

	for i in max_health:
		if i < current_health:
			var heart:= heart_template.duplicate()
			heart.show()
			hearts_container.add_child(heart)
		else:
			var empty_heart:= empty_heart_template.duplicate()
			empty_heart.show()
			hearts_container.add_child(empty_heart)


func update_armour(current_armour: int, max_armour: int):
	# Reset armour_container before re-rendering armour
	for child in armour_container.get_children():
		if child != armour_template and child != empty_armour_template:
			child.queue_free()

	for i in max_armour:
		if i < current_armour:
			var armour:= armour_template.duplicate()
			armour.show()
			armour_container.add_child(armour)
		else:
			var empty_armour:= empty_armour_template.duplicate()
			empty_armour.show()
			armour_container.add_child(empty_armour)


func update_score(new_score: int):
	score_label.text = label_text % new_score
