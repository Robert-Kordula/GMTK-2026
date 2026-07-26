class_name Player
extends CharacterBody2D

signal change_to_health(new_health: int, new_max_health: int)
signal change_to_armour(new_armour: int, new_max_armour: int)
signal killed_npc(points: int)
signal game_ended(sheep_killed: int, final_score: int)

@export var speed:float = 150.0

@export var health: int = 3
@export var max_health: int = 3

@export var armour: int = 1
@export var max_armour: int = 3

@export var damage_velocity: float = 200.0
@export var max_invulnerability_time: float = 0.3

var score: int = 0
var sheep_killed: int = 0

var has_player_taken_damage := false
var invulnerability_time := 0.0
var damage_direction := Vector2(0, 0)

var triggering_game_over: bool = false

@onready var animated_sprite:AnimatedSprite2D = $SeanSprite
@onready var bite_hitbox:Area2D = $BiteHitbox

func _ready():
	animated_sprite.play('right')

func _physics_process(delta):

	if has_player_taken_damage:
		process_damage_knockback(delta)
	else:
		handle_movement_keys()

		handle_input_keys()

	move_and_slide()

# Get the input direction and handle the movement.
func handle_movement_keys():
	var direction:= Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')

	if direction.x > 0:
		animated_sprite.play('right')
	elif direction.x < 0:
		animated_sprite.play('left')

	if direction.x != 0 && direction.y != 0:
		var degree_multiplier = sign(direction.x)

		if direction.y < 0:
			animated_sprite.rotation_degrees = degree_multiplier * -45
		elif direction.y > 0:
			animated_sprite.rotation_degrees = degree_multiplier * 45
	elif direction.x != 0 && direction.y == 0:
		animated_sprite.rotation_degrees = 0
	elif direction.y > 0:
		animated_sprite.play('down')
		animated_sprite.rotation_degrees = 0
	elif direction.y < 0:
		animated_sprite.play('up')
		animated_sprite.rotation_degrees = 0

	if direction != Vector2.ZERO:
		bite_hitbox.look_at(direction + global_position)

	velocity = direction * speed

func handle_input_keys():
	if Input.is_action_just_pressed('melee_attack'):
		bite_hitbox.attack()

func health_change(change_amount: int, new_max_health:= max_health):
	max_health = new_max_health
	health = clamp(health + change_amount, 0, max_health)
	change_to_health.emit(health, new_max_health)

func amour_change(armourChange: int, new_max_armour:= max_armour):
	max_armour = new_max_armour
	armour = clamp(armour - armourChange, 0, max_armour)
	change_to_armour.emit(armour, new_max_armour)

func take_damage(damage: int, direction: Vector2):
	if triggering_game_over:
		return
	health_change(-damage)
	if health <= 0:
		triggering_game_over = true
		call_deferred("game_over")
	else:
		damage_direction = direction
		has_player_taken_damage = true

func process_damage_knockback(delta: float):
	velocity = -damage_direction * damage_velocity
	invulnerability_time += delta

	if invulnerability_time >= max_invulnerability_time:
		animated_sprite.stop()
		has_player_taken_damage = false
		invulnerability_time = 0
		velocity = Vector2(0,0)

func game_over():
	game_ended.emit(sheep_killed, score)

func _on_bite_hitbox_area_entered(area: Area2D):
	var parent = area.get_parent()
	if parent is BaseNPC:
		score += parent.points_for_killing
		killed_npc.emit(score)

		if parent is SheepFodder:
			sheep_killed += 1

		parent.kill_npc()
