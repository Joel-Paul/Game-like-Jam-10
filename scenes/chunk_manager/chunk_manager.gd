class_name ChunkManager
extends Node
## Manages how chunks are generated and stored.
##
## TODO: Implement saving and loading chunks to/from disk.


## Chunk size in voxels.
@export_custom(PROPERTY_HINT_LINK, "suffix:vx") var chunk_size := Vector3i(16, 16, 16)
## Determines the algorithm used to generate chunks.
@export var chunk_generator: ChunkGenerator
## Determines how chunks are rendered. Faces are usually culled for performance.
@export var chunk_mesher: ChunkMesher

## Maps a chunk-aligned position to a chunk object.
var chunks: Dictionary[Vector3i, Chunk] = {}
## The maximum height of the world. This must be set externally.
var max_height: int = 0
## The minimum height of the world. This must be set externally.
var min_height: int = 0


func _ready() -> void:
	chunk_generator.setup()


## Creates, generates, and renders a chunk at the given [param pos].
func generate_chunk(pos: Vector3i) -> void:
	var chunk = Chunk.create(self, pos, chunk_size)
	chunks[pos] = chunk
	chunk_generator.generate(chunk)
	chunk_mesher.generate(chunk)
	call_deferred("add_child", chunk)


## Rerenders the given [param chunk].
func regenerate_mesh(chunk: Chunk) -> void:
	chunk.mesh.clear()
	chunk_mesher.generate(chunk)
	chunk.commit()


## Aligns [param pos] to the chunk-grid.
func snap_pos(pos: Vector3) -> Vector3i:
	return Vector3i(pos / Vector3(chunk_size)) * chunk_size


## Get the chunk from the [param pos].
## The position does not need to be chunk-aligned.
func get_chunk(pos: Vector3i) -> Chunk:
	return chunks.get(snap_pos(pos))


## Get the voxel from the [param pos].
func get_voxel(pos: Vector3i) -> Voxel:
	var chunk = get_chunk(pos)
	if chunk:
		return chunk.get_voxel(pos)
	return null


## Checks if a voxel exists at [param pos].
func has_voxel(pos: Vector3i) -> bool:
	var chunk = get_chunk(pos)
	if chunk:
		return chunk.has_voxel(pos)
	return false


## Sets [param voxel] at [param pos].
func add_voxel(pos: Vector3i, voxel: Voxel) -> void:
	var chunk: Chunk = get_chunk(pos)
	if not chunk:
		var chunk_pos: Vector3i = snap_pos(pos)
		chunk = Chunk.create(self, chunk_pos, chunk_size)
		chunks[chunk_pos] = chunk
		add_child(chunk)
	
	chunk.add_voxel(pos, voxel)
	regenerate_mesh(chunk)


## Removes [param voxel] at [param pos].
func remove_voxel(pos: Vector3i) -> void:
	var chunk: Chunk = get_chunk(pos)
	if not chunk:
		return
	
	chunk.remove_voxel(pos)
	if chunk.voxels.is_empty():
		# NOTE: Don't delete the chunk if saving/loading is implemented.
		chunks.erase(chunk.position)
		chunk.queue_free()
	else:
		regenerate_mesh(chunk)
