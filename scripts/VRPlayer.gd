extends Node3D

var xr_interface: XRInterface

@onready var raycast_left: RayCast3D = $LeftController/MeshInstance3D/RayCast3D
@onready var raycast_right: RayCast3D = $RightController/MeshInstance3D/RayCast3D


func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialised successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")
