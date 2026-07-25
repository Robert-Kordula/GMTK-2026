class_name BaseEnemy
extends BaseNPC

@export var move_speed: int = 50

@export var hitbox_damage: int = 1
@export var attack_speed: float = 2

var player_target: Player;

var can_attack_player: bool
var time_since_attack: float

# Called when the node enters the scene tree for the first time.
func _ready():
	can_attack_player = false
	time_since_attack = attack_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player_target:
		position = position.move_toward(player_target.position, move_speed * delta)

		process_attack(delta)

func process_attack(delta: float):
	if can_attack_player:
		time_since_attack = clamp(delta + time_since_attack, 0, 5)

		if time_since_attack >= attack_speed:
			attack(get_attack_direction())

# Temporary implementation intended to be overridden by clases inheriting this class
func attack(direction: Vector2):
		print('start attack', direction)
		time_since_attack = 0

func _on_hit_box_area_entered(area: Area2D):
	var parent = area.get_parent()
	if parent is Player:
		parent.take_damage(hitbox_damage, get_attack_direction())

func _on_attack_range_area_entered(area: Area2D):
	var parent = area.get_parent()
	if parent is Player:
		can_attack_player = true


func _on_attack_range_area_exited(area: Area2D):
	var parent = area.get_parent()
	if parent is Player:
		can_attack_player = false


func _on_follow_range_area_entered(area):
	var parent = area.get_parent()
	if parent is Player:
		player_target = parent


func _on_follow_range_area_exited(area):
	var parent = area.get_parent()
	if parent is Player:
		player_target = null

func get_attack_direction() -> Vector2:
	if player_target.position.is_finite():
		var direction = position - player_target.position

		return direction.normalized()

	return Vector2.ZERO
