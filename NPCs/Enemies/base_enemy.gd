class_name BaseEnemy
extends BaseNPC

@export var move_speed: int = 50

@export var hitbox_damage: int = 1

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func connect_player(player_reference: Player):
	player = player_reference

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		position = position.move_toward(player.position, move_speed * delta)


func _on_hit_box_area_entered(area: Area2D):
	var parent = area.get_parent()
	if parent == player:
		player.take_damage(hitbox_damage, position - player.position)
