class_name ChunkManager
extends Node


## Chunk size in voxels
@export_custom(PROPERTY_HINT_LINK, "suffix:vx") var chunk_size := Vector3i(16, 16, 16) 
@export var chunk_generator: ChunkGenerator
@export var chunk_mesher: ChunkMesher

var chunks: Dictionary[Vector3i, Chunk] = {}


func generate_chunk(chunk_pos: Vector3i) -> void:
	var chunk = Chunk.create(self, chunk_pos * chunk_size, chunk_size)
	chunks[chunk_pos] = chunk
	chunk_generator.generate(chunk)
	chunk_mesher.generate(chunk)
	call_deferred("add_child", chunk)


func get_chunk(pos: Vector3i) -> Chunk:
	@warning_ignore("integer_division")
	return chunks.get(pos / chunk_size)


func get_voxel(pos: Vector3i) -> Voxel:
	var chunk = get_chunk(pos)
	if chunk:
		return chunk.get_voxel(pos)
	return null


func has_voxel(pos: Vector3i) -> bool:
	var chunk = get_chunk(pos)
	if chunk:
		return chunk.has_voxel(pos)
	return false
