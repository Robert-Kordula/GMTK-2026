class_name BasePowerUp
extends BasePickup

enum PickupEffect {INVINCIBILITY, SPEED_BOOST, DAMAGE_BOOST}

@export var pickup_effect: PickupEffect; 
@export var effect_value: float = 0.0

func on_collect(player: Player):
	match pickup_effect:
		PickupEffect.INVINCIBILITY:
			player.invincibility_pick_up(effect_value)
	
	super(player)