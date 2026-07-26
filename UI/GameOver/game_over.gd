extends CanvasLayer

var score_label_message = "Final score: %s"

@onready var sheep_counter_label: Label = $Control/SheepCounter;
@onready var score_label: Label = $Control/Score;

@onready var root_control: Control = $Control

func _ready() -> void:
	root_control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hide()

func _on_player_game_ended(sheep_killed: int, final_score: int) -> void:
	get_tree().paused = true
	show()
	sheep_counter_label.text = str(sheep_killed)
	score_label.text = score_label_message % final_score


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
