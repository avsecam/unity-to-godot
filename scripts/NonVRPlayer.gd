extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const ROTATION_SPEED = 0.1

const RAY_LENGTH = 1_000

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var camera: Camera3D = $Camera3D
@onready var ray: RayCast3D = $RayCast3D
@onready var anti_peek_ray: RayCast3D = $AntiPeekRaycast

var reset_position: Vector3
var reset_rotation: Vector3

var is_oob := false

func _physics_process(delta):
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	var rotation_input_dir = Input.get_axis("rotate_right", "rotate_left")
	self.rotate_object_local(Vector3.UP, rotation_input_dir * ROTATION_SPEED)
	
	_handle_targeting()
	
	_handle_teleportation()
	
	_handle_anti_peek()


func _handle_targeting():
	var mouse_coords = camera.get_viewport().get_mouse_position()
	
	var from: Vector3 = mesh.position
	from.y += (mesh.mesh as CapsuleMesh).height / 2
	var to: Vector3 = from - camera.project_local_ray_normal(mouse_coords) * RAY_LENGTH
	to.y = -to.y

#	Draw ray
	ray.position = from
	ray.target_position = to


func _handle_teleportation():
#	Ray must only collide with TeleportAreas
	if ray.is_colliding():
		var teleport_area: TeleportArea = ray.get_collider()
		if Input.is_action_just_pressed("click"):
			Events.emit_signal("player_teleport_requested", self, teleport_area)


func _handle_anti_peek():
#	Went oob in this frame
	if not anti_peek_ray.is_colliding() and not is_oob:
		Events.emit_signal("player_went_oob", self)
		is_oob = true
#	Went in bounds in this frame
	elif anti_peek_ray.is_colliding() and is_oob:
		Events.emit_signal("player_went_in_bounds", self)
		is_oob = false
