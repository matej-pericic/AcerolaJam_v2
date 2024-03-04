extends Node3D

@onready var camera: Camera3D = $MinigameCamera
@onready var grabPivot: StaticBody3D = $GrabPivot
@onready var interactiveObjects: Array = get_tree().get_nodes_in_group("MinigameInteractiveObjects")

var grabState: bool = false
var grabJoint: PinJoint3D = PinJoint3D.new()
const LERP_STRENGTH: float = 6.0

func _ready() -> void:
	get_parent().add_child.call_deferred(grabJoint)

func _input(_event: InputEvent) -> void:
	# Raycasting for object grabbing
	if Input.is_action_just_pressed("left_click"):
		var mousePos: Vector2 = get_viewport().get_mouse_position()
		var mouseCollision: Vector3 = ScreenPointToRay(mousePos)[0]
		var mouseCollider: RigidBody3D = ScreenPointToRay(mousePos)[1]

		if mouseCollider != null:
			grabPivot.position = mouseCollision
			grabJoint.position = grabPivot.position
			grabJoint.node_a = mouseCollider.get_path()
			grabJoint.node_b = grabPivot.get_path()
			grabState = true

	if Input.is_action_just_released("left_click"):
		grabState = false
		grabJoint.node_a = ""
# Rotating the camera
	if Input.is_action_just_pressed("turn_left"):
		RotateCamera("rotateLeft")
	if Input.is_action_just_pressed("turn_right"):
		RotateCamera("rotateRight")

func ScreenPointToRay(mousePos: Vector2) -> Array: # Grabs a RigidBody3D
	var spaceState: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	const RAY_LENGTH: float = 2000.0
	var rayOrigin: Vector3 = camera.project_ray_origin(mousePos)
	var rayEnd: Vector3 = rayOrigin + camera.project_ray_normal(mousePos) * RAY_LENGTH
	var rayDict: Dictionary = spaceState.intersect_ray(PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd))

	if rayDict.has("position") && rayDict["collider"] in interactiveObjects:
		return [rayDict["position"], rayDict["collider"]]

	return [Vector3(), null, Vector3()]

func _physics_process(delta: float) -> void:
	# Handles grabbing objects
	if grabState:
		var grabMousePos: Vector2 = get_viewport().get_mouse_position()
		var grabRayOrigin: Vector3 = camera.project_ray_origin(grabMousePos)
		var grabRayLength: float = clampf(grabRayOrigin.distance_to(grabJoint.position), 5.0, 7.0)
		var grabRayEnd: Vector3 = grabRayOrigin + camera.project_ray_normal(grabMousePos) * grabRayLength

		grabPivot.position = grabRayEnd
		grabPivot.position = grabPivot.position.slerp(grabPivot.position, LERP_STRENGTH * delta)

func RotateCamera(rotateDirection: String):
	var rotationAxis: Vector3 = Vector3.UP

	if rotateDirection == "rotateLeft":
		camera.rotate(rotationAxis, deg_to_rad(90))

	if rotateDirection == "rotateRight":
		camera.rotate(rotationAxis, deg_to_rad(-90))

