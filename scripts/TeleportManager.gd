extends Node3D


func _ready():
	Events.player_teleport_requested.connect(_on_player_teleport_requested)
	Events.teleport_area_is_targeted.connect(_on_teleport_area_is_targeted)


func _on_player_teleport_requested(player: Node3D, teleport_area: TeleportArea):
	player.position = teleport_area.teleport_position.global_position
	player.position.y += player.mesh.mesh.height / 2
	player.rotation = teleport_area.teleport_position.global_rotation
	
	player.reset_position = player.position
	player.reset_rotation = player.rotation


func _on_teleport_area_is_targeted(teleport_area: TeleportArea):
	# TODO: Highlight teleport area in some way
	print(teleport_area.name, " is targeted")
