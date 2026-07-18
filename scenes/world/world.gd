extends Node3D


## World size in chunks.
@export_custom(PROPERTY_HINT_LINK, "suffix:ch") var size := Vector3i(3, 3, 3)

@onready var chunk_manager: ChunkManager = $ChunkManager
@onready var player: Player = $Player


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.place_voxel.connect(chunk_manager.add_voxel)
	player.break_voxel.connect(chunk_manager.remove_voxel)
	
	var chunk_size: Vector3i = chunk_manager.chunk_size
	chunk_manager.max_height = size.y * chunk_size.y - 1
	chunk_manager.min_height = 0
	
	player.position.x = size.x * chunk_size.x / 2.0
	player.position.y = size.y * chunk_size.y + 8
	player.position.z = size.z * chunk_size.z / 2.0
	
	generate_chunks()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


## Generates the chunks according to [member size]
func generate_chunks() -> void:
	var total: int = size.x * size.y * size.z
	var i: int = 0
	for x in range(size.x):
		for y in range(size.y):
			for z in range(size.z):
				i += 1
				chunk_manager.generate_chunk(Vector3i(x, y, z) * chunk_manager.chunk_size)
			print("Generated {0}/{1} chunks".format([i, total]))
