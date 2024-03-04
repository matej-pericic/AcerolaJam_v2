extends RigidBody3D

@export var objectData: MinigameInteractiveObjectResource
@export var objectMeshScene: PackedScene
@export var objectMaterial: StandardMaterial3D

@onready var objectName: String
@onready var objectMass: float

func _ready() -> void:

	if objectMeshScene:
		var objectMeshSceneInstance: Node = objectMeshScene.instantiate()
		add_child(objectMeshSceneInstance)
		if objectData:
			objectName = objectData.minigameInteractiveObjectName
			objectMass = objectData.minigameInteractiveObjectMass
			objectMeshSceneInstance.get_child(0).set_mass(objectMass)
		if objectMeshSceneInstance.get_child(0) is RigidBody3D:
			objectMeshSceneInstance.get_child(0).set_use_continuous_collision_detection(true)
			if !objectMeshSceneInstance.get_child(0).is_in_group("MinigameInteractiveObjects"):
				objectMeshSceneInstance.get_child(0).add_to_group("MinigameInteractiveObjects")
			if objectMaterial:
				objectMeshSceneInstance.get_child(0).get_children()[0].set_surface_override_material(0, objectMaterial) # what the fuck

