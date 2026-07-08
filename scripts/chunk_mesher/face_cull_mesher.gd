class_name FaceCullMesher
extends ChunkMesher


func generate(chunk: Chunk) -> void:
	if chunk.voxels.is_empty():
		return
	for pos: Vector3i in chunk.voxels:
		var model: VoxelModel = chunk.voxels[pos].model
		for face in Voxel.Face.values():
			if _face_visible(chunk, pos, face):
				chunk.mesh.add_face(pos, model, face)


func _face_visible(chunk: Chunk, pos: Vector3i, face: Voxel.Face) -> bool:
	var neighbour: Voxel = _get_neighbour(chunk, pos, face)
	if neighbour:
		return neighbour.is_transparent
	return true


func _get_neighbour(chunk: Chunk, pos: Vector3i, face: Voxel.Face) -> Voxel:
	var adj_pos: Vector3i = pos + VoxelModel.get_normal(face)
	return chunk.voxels.get(adj_pos)
