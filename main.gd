extends Node2D

@onready var player: Player = $Player
@onready var hud: Hud = $HUD

# Called when the node enters the scene tree for the first time.
func _ready():
	hud.connect_player(player)
