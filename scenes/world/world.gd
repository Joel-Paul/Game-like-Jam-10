extends Node3D


# Size of the world in chunks
@export_custom(PROPERTY_HINT_LINK, "suffix:ch") var size := Vector3i(3, 3, 3)

var loading_thread := Thread.new()
var _exit_thread := false

@onready var chunk_manager: ChunkManager = $ChunkManager
@onready var player: Player = $Player


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.place_voxel.connect(chunk_manager.add_voxel)
	player.break_voxel.connect(chunk_manager.remove_voxel)

	var chunk_h: int = chunk_manager.chunk_size.y
	chunk_manager.max_height = (size.y + 0) * chunk_h - 1
	chunk_manager.min_height = 0
	
	loading_thread.start(generate_chunks)


func _exit_tree() -> void:
	_exit_thread = true
	loading_thread.wait_to_finish()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func generate_chunks() -> void:
	for x in range(size.x):
		for y in range(size.y):
			for z in range(size.z):
				if _exit_thread:
					return
				chunk_manager.generate_chunk(Vector3i(x, y, z) * chunk_manager.chunk_size)
