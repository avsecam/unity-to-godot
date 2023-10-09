extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.player_teleport_requested.connect(_on_player_teleport_requested)
	Events.oob_timed_out.connect(_on_oob_timed_out)
	

func _blink():
	animation_player.play_backwards("fade")
	

func _on_player_teleport_requested(_player, _teleport_area):
	_blink()


func _on_oob_timed_out():
	_blink()
