extends Node3D


func _ready():
	Events.player_teleport_requested.connect(_on_player_teleport_requested)
	

func _on_player_teleport_requested(player: Node3D, teleport_area: TeleportArea):
	player.position = teleport_area.teleport_position.global_position
	player.position.y += player.mesh.mesh.height / 2
	player.rotation = teleport_area.teleport_position.global_rotation
	
	player.reset_position = player.position
	player.reset_rotation = player.rotation
