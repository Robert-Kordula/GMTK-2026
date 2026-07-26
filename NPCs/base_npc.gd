class_name BaseNPC
extends CharacterBody2D

signal died(entity: BaseNPC, death_position: Vector2)

@export var points_for_killing: int = 0

@onready var hurtBox: Area2D = $HurtBox

func _ready():
	pass


func kill_npc() -> int:
	died.emit(self, global_position)
	queue_free()
	return points_for_killing