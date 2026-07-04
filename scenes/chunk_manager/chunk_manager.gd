class_name ChunkManager
extends Node


## Chunk size in voxels
@export_custom(PROPERTY_HINT_LINK, "suffix:vx") var chunk_size := Vector3i(16, 16, 16) 
@export var chunk_generator: ChunkGenerator
#@export var mesh_generator: ChunkGenerator

var chunks: Dictionary[Vector3i, Chunk] = {}


func generate_chunk(chunk_pos: Vector3i) -> void:
	var chunk = Chunk.create(chunk_pos * chunk_size, chunk_size)
	chunks[chunk_pos] = chunk
	chunk_generator.generate(chunk)
	#chunk.generate_mesh()
	call_deferred("add_child", chunk)
