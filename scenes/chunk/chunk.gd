class_name Chunk
extends StaticBody3D
## Stores positions of voxels within this chunk.


const _CHUNK = preload("uid://du16hg66uur71")

## Material of this chunk. Uses shaders to select textures per voxel.
@export var material: Material

## Manages how this chunk is generated and managed.
var manager: ChunkManager
## Chunk size in voxels. Set externally and used for reference.
var size: Vector3i
## Maps a position to a voxel object.
var voxels: Dictionary[Vector3i, Voxel] = {}
## Stores info about the mesh,
var mesh := ChunkMesh.new()

## Mesh of the chunk.
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
## Defines the collision of the chunk. This is generated from the mesh.
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


## Create a chunk. This does not add it to the tree, which needs to be done separately.
static func create(chunk_manager: ChunkManager, chunk_pos: Vector3i, chunk_size: Vector3i) -> Chunk:
	var chunk: Chunk = _CHUNK.instantiate()
	chunk.manager = chunk_manager
	chunk.position = chunk_pos
	chunk.size = chunk_size
	return chunk


func _ready() -> void:
	if not voxels.is_empty():
		commit()


## Gets the voxel in this chunk, assuming [param pos] is inside this chunk.
func get_voxel(pos: Vector3i) -> Voxel:
	return voxels.get(pos % size)


## Checks if a voxel is in this chunk, assuming [param pos] is inside this chunk.
func has_voxel(pos: Vector3i) -> bool:
	return voxels.has(pos % size)


## Sets [param voxel] in this chunk at [param pos]. Assumes [param pos] is inside this chunk.
func add_voxel(pos: Vector3i, voxel: Voxel) -> bool:
	return voxels.set(pos % size, voxel)


## Deletes [param voxel] in this chunk at [param pos]. Assumes [param pos] is inside this chunk.
func remove_voxel(pos: Vector3i) -> bool:
	return voxels.erase(pos % size)


## Sets the mesh and collision for this chunk.
func commit() -> void:
	mesh.commit()
	
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh.arrays)
	array_mesh.surface_set_material(0, material)
	
	mesh_instance_3d.mesh = array_mesh
	collision_shape_3d.shape = array_mesh.create_trimesh_shape()


## Contains information about the chunk's mesh.
class ChunkMesh:
	var arrays: Array = []
	var vertices := PackedVector3Array()
	var normals := PackedVector3Array()
	var uvs := PackedVector2Array()
	var texture_indecies := PackedVector2Array()
	
	
	## Appends the [param face] of a [param model] to the [param pos].
	func add_face(pos: Vector3i, model: VoxelModel, face: Voxel.Face) -> void:
		vertices.append_array(model.get_vertices(face, pos))
		normals.append_array(model.get_normals(face))
		uvs.append_array(model.get_uvs(face))
		texture_indecies.append_array(model.get_texture_indecies(face))
	
	
	## Sets the surface array mesh information.
	func commit() -> void:
		arrays.resize(Mesh.ARRAY_MAX)
		arrays[Mesh.ARRAY_VERTEX] = vertices
		arrays[Mesh.ARRAY_NORMAL] = normals
		arrays[Mesh.ARRAY_TEX_UV] = uvs
		arrays[Mesh.ARRAY_TEX_UV2] = texture_indecies
	
	
	## Resets the surface array mesh information.
	func clear() -> void:
		arrays = []
		vertices = PackedVector3Array()
		normals = PackedVector3Array()
		uvs = PackedVector2Array()
		texture_indecies = PackedVector2Array()
