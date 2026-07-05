extends Node3D


@onready var chunk_manager: ChunkManager = $Terrain/ChunkManager
@onready var player: Player = $Player


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.place_voxel.connect(chunk_manager.add_voxel)
	player.break_voxel.connect(chunk_manager.remove_voxel)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
