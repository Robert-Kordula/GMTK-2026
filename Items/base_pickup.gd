class_name BasePickup
extends Area2D

func _on_area_entered(area: Area2D):
	var parent = area.get_parent()

	if parent is Player:
		on_collect(parent)


func on_collect(_player: Player):
	queue_free()
