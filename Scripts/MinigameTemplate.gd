extends Node3D
class_name Minigame

@onready var interactiveObjects: Array = get_tree().get_nodes_in_group("MinigameInteractiveObjects")
@onready var minigamePlayer: Node3D = $MinigamePlayer

