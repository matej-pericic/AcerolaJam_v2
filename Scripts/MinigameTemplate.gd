extends Node3D
class_name Minigame

@onready var camera: Camera3D = $MinigameCamera
@onready var interactiveObjects: Array = get_tree().get_nodes_in_group("MinigameInteractiveObjects")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		var mousePos: Vector2 = get_viewport().get_mouse_position()
		var mouseCollision: Vector3 = ScreenPointToRay(mousePos)[0]
		var mouseCollider: RigidBody3D = ScreenPointToRay(mousePos)[1]
		var mouseCollisionNormal: Vector3 = ScreenPointToRay(mousePos)[2]
		
		if mouseCollider != null:
			mouseCollider.apply_impulse(-mouseCollisionNormal, mouseCollision)

func ScreenPointToRay(mousePos: Vector2) -> Array:
	var spaceState: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	
	const RAY_LENGTH: float = 2000.0
	var rayOrigin: Vector3 = camera.project_ray_origin(mousePos)
	var rayEnd: Vector3 = rayOrigin + camera.project_ray_normal(mousePos) * RAY_LENGTH
	var rayDict: Dictionary = spaceState.intersect_ray(PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd))
	
	if rayDict.has("position") && rayDict["collider"] in interactiveObjects:
		return [rayDict["position"], rayDict["collider"], rayDict["normal"]]
	
	return [Vector3(), null, Vector3()]

