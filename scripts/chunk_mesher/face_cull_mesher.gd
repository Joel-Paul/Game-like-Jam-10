class_name FaceCullMesher
extends ChunkMesher


func generate(chunk: Chunk) -> void:
	if chunk.voxels.is_empty():
		return
	for pos: Vector3i in chunk.voxels:
		var model: VoxelModel = chunk.voxels[pos].model
		for face in Voxel.Face.values():
			if not _has_neighbour(chunk, pos, face):
				chunk.mesh.add_face(pos, model, face)


func _has_neighbour(chunk: Chunk, pos: Vector3i, face: Voxel.Face) -> bool:
	var adj_pos: Vector3i = pos + VoxelModel.get_normal(face)
	return chunk.voxels.has(adj_pos)
