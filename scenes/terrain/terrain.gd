class_name Terrain
extends Node


var loading_thread := Thread.new()

@onready var chunk_manager: ChunkManager = $ChunkManager


func _ready() -> void:
	loading_thread.start(generate_chunks)


func _exit_tree() -> void:
	loading_thread.wait_to_finish()


## Takes the [param size] of the area to generate in chunks.
func generate_chunks(size := Vector3i(3, 3, 3)) -> void:
	for x in range(size.x):
		for y in range(size.y):
			for z in range(size.z):
				chunk_manager.generate_chunk(Vector3i(x, y, z))
