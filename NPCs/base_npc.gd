class_name BaseNPC
extends RigidBody2D

@export var points_for_killing: int = 0

@onready var hurtBox: Area2D = $HurtBox

func _ready():
	pass


func kill_npc():
	queue_free()
	return points_for_killing