extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.player_teleport_requested.connect(_on_player_teleport_requested)
	

func _on_player_teleport_requested(_player, _teleport_area):
	animation_player.play_backwards("fade")
