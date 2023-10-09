extends Control


@export var max_time_before_reset: float = 2
@onready var current_time_before_reset: float = max_time_before_reset

var notif_visible := false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer_label: Label = $VBoxContainer/TimerLabel


func _ready():
	
	Events.player_went_oob.connect(_on_player_went_oob)
	Events.player_went_in_bounds.connect(_on_player_went_in_bounds)


func _physics_process(delta):
	if notif_visible:
		current_time_before_reset -= delta
		
		timer_label.text = str(current_time_before_reset).pad_decimals(2)
	
	if not notif_visible:
		current_time_before_reset = max_time_before_reset


func _on_player_went_oob(player: Node3D):
	if not notif_visible:
		notif_visible = true
		animation_player.play("fade")


func _on_player_went_in_bounds(player: Node3D):
	if notif_visible:
		notif_visible = false
		animation_player.play_backwards("fade")
