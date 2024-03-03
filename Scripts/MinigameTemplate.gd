extends Node3D
class_name Minigame

@onready var camera: Camera3D = $MinigameCamera
@onready var grabPivot: StaticBody3D = $GrabPivot
@onready var interactiveObjects: Array = get_tree().get_nodes_in_group("MinigameInteractiveObjects")

var grabState: bool = false
var grabJoint: PinJoint3D = PinJoint3D.new()

func _ready() -> void:
	get_parent().add_child.call_deferred(grabJoint)

func _input(_event: InputEvent) -> void:
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

func ScreenPointToRay(mousePos: Vector2) -> Array: # Grabs a RigidBody3D
	var spaceState: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	const RAY_LENGTH: float = 2000.0
	var rayOrigin: Vector3 = camera.project_ray_origin(mousePos)
	var rayEnd: Vector3 = rayOrigin + camera.project_ray_normal(mousePos) * RAY_LENGTH
	var rayDict: Dictionary = spaceState.intersect_ray(PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd))
	
	if rayDict.has("position") && rayDict["collider"] in interactiveObjects:
		return [rayDict["position"], rayDict["collider"]]
	
	return [Vector3(), null, Vector3()]

func _physics_process(_delta: float) -> void:
	# Handles grabbing objects, TODO: fix pushing objects through the floor
	if grabState:
		var grabMousePos: Vector2 = get_viewport().get_mouse_position()
		var grabRayOrigin: Vector3 = camera.project_ray_origin(grabMousePos)
		var grabRayLength: float = grabRayOrigin.distance_to(grabPivot.position)
		var grabRayEnd: Vector3 = grabRayOrigin + camera.project_ray_normal(grabMousePos) * grabRayLength
		
		grabPivot.position = grabRayEnd
