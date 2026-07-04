class_name CubeModel
extends VoxelModel


func get_vertices(face: Voxel.Face) -> PackedVector3Array:
	return quad_to_tris(_get_quad_vertices(face))


func get_normals(face: Voxel.Face) -> PackedVector3Array:
	var arr := PackedVector3Array()
	arr.resize(6)
	arr.fill(_get_normal(face))
	return arr


func get_colors(_face: Voxel.Face) -> PackedColorArray:
	var arr := PackedColorArray()
	arr.resize(6)
	arr.fill(Color.WHITE)
	return arr


func _get_quad_vertices(face: Voxel.Face) -> PackedVector3Array:
	match face:
		Voxel.Face.FRONT:
			return PackedVector3Array([
				Vector3(0, 0, 0),
				Vector3(1, 0, 0),
				Vector3(1, 1, 0),
				Vector3(0, 1, 0)
			])
		Voxel.Face.BACK:
			return PackedVector3Array([
				Vector3(1, 1, 1),
				Vector3(1, 0, 1),
				Vector3(0, 0, 1),
				Vector3(0, 1, 1),
			])
		Voxel.Face.LEFT:
			return PackedVector3Array([
				Vector3(0, 0, 0),
				Vector3(0, 1, 0),
				Vector3(0, 1, 1),
				Vector3(0, 0, 1),
			])
		Voxel.Face.RIGHT:
			return PackedVector3Array([
				Vector3(1, 1, 1),
				Vector3(1, 1, 0),
				Vector3(1, 0, 0),
				Vector3(1, 0, 1),
			])
		Voxel.Face.TOP:
			return PackedVector3Array([
				Vector3(1, 1, 1),
				Vector3(0, 1, 1),
				Vector3(0, 1, 0),
				Vector3(1, 1, 0),
			])
		Voxel.Face.BOTTOM, _:
			return PackedVector3Array([
				Vector3(0, 0, 0),
				Vector3(0, 0, 1),
				Vector3(1, 0, 1),
				Vector3(1, 0, 0),
			])


func _get_normal(face: Voxel.Face) -> Vector3:
	match face:
		Voxel.Face.FRONT:
			return Vector3.FORWARD
		Voxel.Face.BACK:
			return Vector3.BACK
		Voxel.Face.LEFT:
			return Vector3.LEFT
		Voxel.Face.RIGHT:
			return Vector3.RIGHT
		Voxel.Face.TOP:
			return Vector3.UP
		Voxel.Face.BOTTOM, _:
			return Vector3.DOWN
