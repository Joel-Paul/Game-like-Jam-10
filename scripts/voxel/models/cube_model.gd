class_name CubeModel
extends VoxelModel
## A full cube.


func get_vertices(face: Voxel.Face, offset := Vector3i.ZERO) -> PackedVector3Array:
	return quad_to_tris(_get_quad_vertices(face, offset))


func get_normals(face: Voxel.Face) -> PackedVector3Array:
	var arr := PackedVector3Array()
	arr.resize(6)
	arr.fill(get_normal(face))
	return arr


func get_uvs(_face: Voxel.Face) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(1, 1),
		Vector2(0, 1),
		Vector2(0, 0),
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(1, 1),
	])


## Returns the square vertices for a given [param face].
## [param offset] moves the vertices to place
## them at the correct position in the world.
func _get_quad_vertices(face: Voxel.Face, offset := Vector3i.ZERO) -> PackedVector3Array:
	match face:
		Voxel.Face.FRONT:
			return PackedVector3Array([
				Vector3i(0, 0, 0) + offset,
				Vector3i(1, 0, 0) + offset,
				Vector3i(1, 1, 0) + offset,
				Vector3i(0, 1, 0) + offset,
			])
		Voxel.Face.BACK:
			return PackedVector3Array([
				Vector3i(1, 0, 1) + offset,
				Vector3i(0, 0, 1) + offset,
				Vector3i(0, 1, 1) + offset,
				Vector3i(1, 1, 1) + offset,
			])
		Voxel.Face.LEFT:
			return PackedVector3Array([
				Vector3i(0, 0, 1) + offset,
				Vector3i(0, 0, 0) + offset,
				Vector3i(0, 1, 0) + offset,
				Vector3i(0, 1, 1) + offset,
			])
		Voxel.Face.RIGHT:
			return PackedVector3Array([
				Vector3i(1, 0, 0) + offset,
				Vector3i(1, 0, 1) + offset,
				Vector3i(1, 1, 1) + offset,
				Vector3i(1, 1, 0) + offset,
			])
		Voxel.Face.TOP:
			return PackedVector3Array([
				Vector3i(0, 1, 0) + offset,
				Vector3i(1, 1, 0) + offset,
				Vector3i(1, 1, 1) + offset,
				Vector3i(0, 1, 1) + offset,
			])
		Voxel.Face.BOTTOM, _:
			return PackedVector3Array([
				Vector3i(0, 0, 1) + offset,
				Vector3i(1, 0, 1) + offset,
				Vector3i(1, 0, 0) + offset,
				Vector3i(0, 0, 0) + offset,
			])
