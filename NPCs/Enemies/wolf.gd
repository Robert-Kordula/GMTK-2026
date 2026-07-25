class_name WolfEnemy
extends BaseEnemy

@export_group("Wolf Pounce Settings")
@export var pounce_distance: float = 120.0     # Fixed leap distance to ensure doesn't go too far / past player
@export var warning_time: float = 0.4          # Pause before leaping (gives player time to dodge?)
@export var leap_time: float = 0.25            # Speed of the leap 
@export var recovery_time: float = 0.2          # Pause after landing before walking/attacking again

var is_pouncing: bool = false

func _physics_process(delta):
	# Stop BaseEnemy's normal walk while telegraphing, leaping, or recovering
	if is_pouncing:
		return
		
	super._physics_process(delta)

func attack(direction: Vector2):
	super.attack(direction)
	pounce()

func pounce():
	if is_pouncing or not player_target:
		return
		
	is_pouncing = true
	
	# 1 Initiate attack
	# The wolf stops moving and locks onto the player's CURRENT position.
	var target_spot = player_target.global_position
	
	var pounce_dir = (target_spot - global_position).normalized()
	if pounce_dir == Vector2.ZERO:
		pounce_dir = Vector2.RIGHT # Fallback 
		
	# Calculate target (player)
	var final_pounce_pos = global_position + (pounce_dir * pounce_distance)
	
	# Pause to alert player 
	await get_tree().create_timer(warning_time).timeout
	
	# 2 Wolf Leaps
	# Quick leap towards player
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", final_pounce_pos, leap_time)
	
	await tween.finished
	
	# 3 Wolf Recovery
	# Wolf sits still - maybe gives player chance to attack back if that's going to be added?
	await get_tree().create_timer(recovery_time).timeout
	
	# Reset state
	is_pouncing = false
