@abstract
class_name VoxelModel
extends Resource


var color: Color


static func get_normal(face: Voxel.Face) -> Vector3i:
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


static func quad_to_tris(vertices: PackedVector3Array) -> PackedVector3Array:
	return PackedVector3Array([
		vertices[0],
		vertices[1],
		vertices[2],
		vertices[2],
		vertices[3],
		vertices[0],
	])


func _init(model_color: Color) -> void:
	color = model_color


@abstract func get_vertices(face: Voxel.Face, offset := Vector3i.ZERO) -> PackedVector3Array


@abstract func get_normals(face: Voxel.Face) -> PackedVector3Array


@abstract func get_colors(face: Voxel.Face) -> PackedColorArray


@abstract func get_uvs(face: Voxel.Face) -> PackedVector2Array
