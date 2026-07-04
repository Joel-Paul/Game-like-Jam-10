@abstract
class_name VoxelModel
extends Resource


@abstract func get_vertices(face: Voxel.Face) -> PackedVector3Array


@abstract func get_normals(face: Voxel.Face) -> PackedVector3Array


@abstract func get_colors(face: Voxel.Face) -> PackedColorArray


static func quad_to_tris(vertices: PackedVector3Array) -> PackedVector3Array:
	return PackedVector3Array([
		vertices[0],
		vertices[1],
		vertices[2],
		vertices[2],
		vertices[3],
		vertices[0],
	])
