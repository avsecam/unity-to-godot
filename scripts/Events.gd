extends Node


signal player_teleport_requested(player: Node3D, teleport_area: TeleportArea)

signal player_went_oob(player: Node3D)
signal player_went_in_bounds(player: Node3D)

signal oob_timed_out()
