class_name Player
extends CharacterBody2D

signal change_to_health(new_health: int, new_max_health: int)
signal change_to_armour(new_armour: int, new_max_armour: int)

@export var speed:float = 300.0

@export var health: int = 3
@export var max_health: int = 3

@export var armour: int = 1
@export var max_armour: int = 3

@onready var animated_sprite:AnimatedSprite2D = $SeanSprite
@onready var bite_hitbox:Area2D = $BiteHitbox

func _ready():
	animated_sprite.play('right')

func _physics_process(_delta):

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

func health_change(healthChange: int, new_max_health:= max_health):
	max_health = new_max_health
	health = clamp(health - healthChange, 0, max_health)
	change_to_health.emit(health, new_max_health)

func amour_change(armourChange: int, new_max_armour:= max_armour):
	max_armour = new_max_armour
	armour = clamp(armour - armourChange, 0, max_armour)
	change_to_armour.emit(armour, new_max_armour)
