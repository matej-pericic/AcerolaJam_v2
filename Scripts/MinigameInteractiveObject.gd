extends RigidBody3D
class_name MinigameInteractiveObject

@export var minigameInteractiveObjectShape: Shape3D
@export var minigameInteractiveObjectMesh: Mesh
@onready var minigameInteractiveObjectCollisionShape: CollisionShape3D = $MinigameInteractiveObjectCollisionShape
@onready var minigameInteractiveObjectMeshInstance: MeshInstance3D = $MinigameInteractiveObjectMeshInstance


func _ready() -> void:
	if minigameInteractiveObjectShape != null:
		minigameInteractiveObjectCollisionShape.shape = minigameInteractiveObjectShape
	if minigameInteractiveObjectMesh != null:
		minigameInteractiveObjectMeshInstance.mesh = minigameInteractiveObjectMesh
