class_name Terrain
extends Node



# Size of the world in chunks
@export_custom(PROPERTY_HINT_LINK, "suffix:c") var size := Vector3i(3, 3, 3)

var loading_thread := Thread.new()

@onready var chunk_manager: ChunkManager = $ChunkManager


func _ready() -> void:
	loading_thread.start(generate_chunks)


func _exit_tree() -> void:
	loading_thread.wait_to_finish()


func generate_chunks() -> void:
	for x in range(size.x):
		for y in range(size.y):
			for z in range(size.z):
				@warning_ignore("integer_division")
				chunk_manager.generate_chunk(Vector3i(x, y, z) - size / 2)
