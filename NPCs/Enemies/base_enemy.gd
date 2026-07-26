class_name BaseEnemy
extends BaseNPC

@export var move_speed: int = 100

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
		var direction := global_position.direction_to(
			player_target.global_position
		)

		velocity = direction * move_speed

	else:
		velocity = Vector2.ZERO

	move_and_slide()
	process_attack(delta)

func process_attack(delta: float):
	if can_attack_player:
		time_since_attack = clamp(delta + time_since_attack, 0, 5)

		if time_since_attack >= attack_speed:
			attack(get_attack_direction())

# Temporary implementation intended to be overridden by clases inheriting this class
func attack(_direction: Vector2):
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


func _on_follow_range_area_entered(area: Area2D):
	var parent = area.get_parent()
	if parent is Player:
		player_target = parent


func _on_follow_range_area_exited(area):
	var parent = area.get_parent()
	if parent is Player:
		player_target = null

func get_attack_direction() -> Vector2:
	if player_target.global_position.is_finite():
		var direction = global_position - player_target.global_position

		return direction.normalized()

	return Vector2.ZERO
