class_name FaceCullMesher
extends ChunkMesher
## Culls faces that are adjacent to other blocks.
##
## NOTE: This does not cull faces across chunk boundaries.


func generate(chunk: Chunk) -> void:
	if chunk.voxels.is_empty():
		return
	for pos: Vector3i in chunk.voxels:
		var model: VoxelModel = chunk.voxels[pos].model
		for face in Voxel.Face.values():
			if _is_face_exposed(chunk, pos, face):
				chunk.mesh.add_face(pos, model, face)


## Only render the face if it is exposed.
func _is_face_exposed(chunk: Chunk, pos: Vector3i, face: Voxel.Face) -> bool:
	var neighbour: Voxel = _get_neighbour(chunk, pos, face)
	if neighbour:
		## Don't cull for transparent voxels, since you can see through them
		return neighbour.is_transparent
	return true


## Get the voxel adjacent to this one.
func _get_neighbour(chunk: Chunk, pos: Vector3i, face: Voxel.Face) -> Voxel:
	var adj_pos: Vector3i = pos + VoxelModel.get_normal(face)
	return chunk.voxels.get(adj_pos)
