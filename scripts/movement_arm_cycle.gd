extends "res://addons/godot-xr-tools/functions/movement_provider.gd"


## Movement provider order
@export var order : int = 10


#	With arm–cycling, when the triggers on both the left (L) and right
#	(R) controllers are pressed, the x and z coordinates for the controllers are saved (oldLx , oldLz , oldRx , oldRz ). During a frame
#	where both triggers are held down, new positions of the controllers are recorded (currLx ,currLz ,currRx ,currRz ). During that
#	frame, the user is translated forward in the yaw-direction of their
#	HMD by the sum of the absolute differences in the movement between frames of the controllers: Translation Amount = (|oldLx −
#	currLx |,0, |oldLz −currLz |) +(|oldRx −currRx |,0, |oldRz −currRz |).
#	Before the next frame, oldLx ,oldLz ,oldRx ,oldRz are over-written
#	and assigned the values currLx ,currLz , currRx ,currRz , respectively. The effect is forward movement at a speed determined by
#	the speed of controller movement. When either trigger is released,
#	the controllers cease to control locomotion

@onready var left_hand := XRHelpers.get_left_controller(self)
@onready var right_hand := XRHelpers.get_right_controller(self)
@onready var hmd := XRHelpers.get_xr_camera(self)
@onready var player_body := XRToolsPlayerBody.find_instance(self)
@onready var origin := self.get_parent().get_parent()


var left_hand_old_pos := Vector3.ZERO
var right_hand_old_pos := Vector3.ZERO


# Add support for is_xr_class on XRTools classes
func is_xr_class(name : String) -> bool:
	return name == "XRToolsMovementArmCycle" or super(name)
	
func _ready():
	left_hand_old_pos = left_hand.position
	right_hand_old_pos = right_hand.position


func _physics_process(delta):
	var left_hand_new_pos := left_hand.position
	var right_hand_new_pos := right_hand.position
	if _both_buttons_are_fully_pressed():
		var translation_amount := Vector3(
			abs(left_hand_old_pos.x - left_hand_new_pos.x) + \
				abs(right_hand_old_pos.x - right_hand_new_pos.x),
			0,
			abs(left_hand_old_pos.z - left_hand_new_pos.z) + \
				abs(right_hand_old_pos.z - right_hand_new_pos.z)
		)
		
		origin.global_position += -hmd.global_transform.basis.z * translation_amount
	
	# Reset old_pos values
	left_hand_old_pos = left_hand_new_pos
	right_hand_old_pos = right_hand_new_pos


func _both_buttons_are_fully_pressed():
	return left_hand.get_float("grip") >= 1 && right_hand.get_float("grip") >= 1

#func physics_movement(_delta: float, player_body: XRToolsPlayerBody, _disabled: bool):
#	player_body.ground_control_velocity.y += 10
