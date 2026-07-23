extends Area2D

@export var total_attack_time:float = 0.5

var is_attacking : bool = false;
var attack_time: float = 0

func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_attacking:
		attack_time += delta
		if attack_time >= total_attack_time:
			attack_trigger(false)
			

func _draw():
	draw_arc(
		Vector2.ZERO,
		20,
		-PI / 4,
		PI / 4,
		24,
		Color.WHITE,
		16)

func attack():
	if !is_attacking:
		print('setting to true')
		attack_trigger(true)

func attack_trigger(state: bool):
	is_attacking = state
	visible = state
	if !state:
		attack_time = 0