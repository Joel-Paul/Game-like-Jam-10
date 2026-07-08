@abstract
class_name VoxelModel
extends Resource


## A map between the face of the voxel and the index of the texture.
## Only the x position of the vector is used for now, which denotes the index.
## This should not be set directly, instead use
## [method set_texture], [method set_texture_all], or [method set_texture_sides].
var texture_face: Dictionary[Voxel.Face, Vector2] = {
	Voxel.Face.FRONT: Vector2.ZERO,
	Voxel.Face.BACK: Vector2.ZERO,
	Voxel.Face.LEFT: Vector2.ZERO,
	Voxel.Face.RIGHT: Vector2.ZERO,
	Voxel.Face.TOP: Vector2.ZERO,
	Voxel.Face.BOTTOM: Vector2.ZERO,
}


## Returns the normal for a given [param face].
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


## Converts 4 points describing a square into 6 points describing two triangles.
static func quad_to_tris(vertices: PackedVector3Array) -> PackedVector3Array:
	return PackedVector3Array([
		vertices[0],
		vertices[1],
		vertices[2],
		vertices[2],
		vertices[3],
		vertices[0],
	])


## Sets the texture of the [param face] to [param texture_name].
func set_texture(face: Voxel.Face, texture_name: StringName) -> VoxelModel:
	var index = Textures.texture_map.get(texture_name, 0)
	texture_face[face] = Vector2(index, 0)
	return self


## Sets the texture of all faces to [param texture_name].
func set_texture_all(texture_name: StringName) -> VoxelModel:
	for face: Voxel.Face in Voxel.Face.values():
		set_texture(face, texture_name)
	return self


## Sets the texture of side faces to [param texture_name].
func set_texture_sides(texture_name: StringName) -> VoxelModel:
	for face in [Voxel.Face.FRONT, Voxel.Face.BACK, Voxel.Face.LEFT, Voxel.Face.RIGHT]:
		set_texture(face, texture_name)
	return self


## Returns the texture indecies for a given [param face].
func get_texture_indecies(face: Voxel.Face) -> PackedVector2Array:
	var arr := PackedVector2Array()
	arr.resize(6)
	arr.fill(texture_face[face])
	return arr


## Returns the triangle vertices for a given [param face].
## [param offset] moves the vertices to place
## them at the correct position in the world.
@abstract func get_vertices(face: Voxel.Face, offset := Vector3i.ZERO) -> PackedVector3Array


## Returns the normals for a given [param face].
@abstract func get_normals(face: Voxel.Face) -> PackedVector3Array


## Returns the uvs for a given [param face].
@abstract func get_uvs(face: Voxel.Face) -> PackedVector2Array
