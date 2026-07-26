class_name Player
extends CharacterBody2D

signal change_to_health(new_health: int, new_max_health: int)
signal changed_max_health(new_max_health: int)
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

var invincibility_timer: float = 0.0
var player_speed_boost: float = 1.0
var player_speed_boost_timer: float = 0.0

var damage_tween: Tween
var invincibility_tween: Tween


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

	if invincibility_timer > 0 or player_speed_boost_timer > 0:
		handle_power_up_effects(delta)
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
	changed_max_health.emit(new_max_health)

func armour_change(change_amount: int, new_max_armour:= max_armour) -> int:
	max_armour = new_max_armour
	var new_armour = armour + change_amount
	armour = clamp(armour + change_amount, 0, max_armour)
	change_to_armour.emit(armour, new_max_armour)

	if new_armour < 0:
		return new_armour

	return 0


func take_damage(damage: int, direction: Vector2):
	if triggering_game_over:
		return

	if invincibility_timer > 0.0:
		return

	if has_player_taken_damage:
		return

	flash_damage()

	var armour_overflow: int = armour_change(-damage)

	health_change(armour_overflow)
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


func handle_power_up_effects(delta: float) -> void:
	if invincibility_timer > 0.0:
		invincibility_timer = maxf(invincibility_timer - delta, 0.0)

		if invincibility_timer == 0.0:
			kill_invincibility_tween()

	if player_speed_boost_timer > 0.0:
		player_speed_boost_timer = maxf(
			player_speed_boost_timer - delta,
			0.0
		)

		if player_speed_boost_timer == 0.0:
			player_speed_boost = 1.0


func invincibility_pick_up(time_to_apply: float) -> void:
	print("Applying invincibility: ", time_to_apply)
	invincibility_timer = time_to_apply
	rainbow_flash()


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

func clear_tweens():
	kill_damage_tween()
	kill_invincibility_tween()



func kill_damage_tween() -> void:
	if damage_tween and damage_tween.is_valid():
		damage_tween.kill()

	damage_tween = null
	animated_sprite.modulate = Color.WHITE


func kill_invincibility_tween() -> void:
	if invincibility_tween and invincibility_tween.is_valid():
		invincibility_tween.kill()

	invincibility_tween = null
	animated_sprite.modulate = Color.WHITE


func flash_damage():
	clear_tweens()

	damage_tween = create_tween()
	var animation_time = max_invulnerability_time / 6

	damage_tween.tween_property(animated_sprite, "modulate", Color(1.0, 0.4, 0.4), animation_time)
	damage_tween.tween_property(animated_sprite, "modulate", Color.WHITE, animation_time)

	damage_tween.tween_property(animated_sprite, "modulate", Color(1.0, 0.4, 0.4), animation_time)
	damage_tween.tween_property(animated_sprite, "modulate", Color.WHITE,animation_time)

	damage_tween.tween_property(animated_sprite, "modulate", Color(1.0, 0.4, 0.4), animation_time)
	damage_tween.tween_property(animated_sprite, "modulate", Color.WHITE, animation_time)

func rainbow_flash(duration := 1.0):
	clear_tweens()

	invincibility_tween = create_tween()
	invincibility_tween.set_loops()

	const STEPS := 12

	for i in STEPS:
		var hue := float(i) / STEPS
		var colour := Color.from_hsv(hue, 1.0, 1.0)

		invincibility_tween.tween_property(
			animated_sprite,
			"modulate",
			colour,
			duration / STEPS
		)
