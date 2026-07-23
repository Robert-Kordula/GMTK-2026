extends CharacterBody2D

@export var speed = 300.0

func _physics_process(_delta):

	handle_movement_keys()

	move_and_slide()

# Get the input direction and handle the movement.
func handle_movement_keys():
	var x_direction = Input.get_axis("move_left", "move_right")
	var y_direction = Input.get_axis("move_up", "move_down")

	var direction:= Vector2(x_direction, y_direction)

	velocity = direction.normalized() * speed