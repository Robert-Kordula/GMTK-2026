class_name BasePowerUp
extends BasePickup

enum PickupEffect {INVINCIBILITY, SPEED_BOOST, DAMAGE_BOOST, INCREASE_MAX_HEALTH, INCREASE_MAX_ARMOUR, INCREASE_HEALTH}

@export var pickup_effect: PickupEffect; 
@export var effect_value: float = 0.0

func on_collect(player: Player):
	match pickup_effect:
		PickupEffect.INVINCIBILITY:
			player.invincibility_pick_up(effect_value)
	match pickup_effect:
		PickupEffect.INCREASE_MAX_HEALTH:
			player.health_change(1, int(player.max_health + effect_value))
	match pickup_effect: 
		PickupEffect.INCREASE_HEALTH:
			player.health_change(1)
	super(player)