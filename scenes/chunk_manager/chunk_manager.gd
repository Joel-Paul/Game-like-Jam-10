class_name ChunkManager
extends Node


## Chunk size in voxels
@export_custom(PROPERTY_HINT_LINK, "suffix:vx") var chunk_size := Vector3i(16, 16, 16) 
@export var chunk_generator: ChunkGenerator
@export var chunk_mesher: ChunkMesher

var chunks: Dictionary[Vector3i, Chunk] = {}
var max_height: int = 0
var min_height: int = 0


func _ready() -> void:
	chunk_generator.setup()


func generate_chunk(chunk_pos: Vector3i) -> void:
	var chunk = Chunk.create(self, chunk_pos * chunk_size, chunk_size)
	chunks[chunk_pos] = chunk
	chunk_generator.generate(chunk)
	chunk_mesher.generate(chunk)
	call_deferred("add_child", chunk)


func regenerate_mesh(chunk: Chunk) -> void:
	chunk.mesh.clear()
	chunk_mesher.generate(chunk)
	chunk.commit()


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


func add_voxel(pos: Vector3i, voxel: Voxel) -> void:
	var chunk: Chunk = get_chunk(pos)
	if not chunk:
		@warning_ignore("integer_division")
		var chunk_pos: Vector3i = pos / chunk_size
		chunk = Chunk.create(self, chunk_pos * chunk_size, chunk_size)
		chunks[chunk_pos] = chunk
		add_child(chunk)
	
	chunk.add_voxel(pos, voxel)
	regenerate_mesh(chunk)


func remove_voxel(pos: Vector3i) -> void:
	var chunk: Chunk = get_chunk(pos)
	if not chunk:
		return
	
	chunk.remove_voxel(pos)
	if chunk.voxels.is_empty():
		chunks.erase(chunk.position)
		chunk.queue_free()
	else:
		regenerate_mesh(chunk)
