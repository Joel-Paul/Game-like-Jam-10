class_name Chunk
extends StaticBody3D


const _CHUNK = preload("uid://du16hg66uur71")

@export var material: Material

var manager: ChunkManager
var size: Vector3i
var voxels: Dictionary[Vector3i, Voxel] = {}
var mesh := ChunkMesh.new()

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D


static func create(chunk_manager: ChunkManager, chunk_pos: Vector3i, chunk_size: Vector3i) -> Chunk:
	var chunk: Chunk = _CHUNK.instantiate()
	chunk.manager = chunk_manager
	chunk.position = chunk_pos
	chunk.size = chunk_size
	return chunk


func _ready() -> void:
	if not voxels.is_empty():
		commit()


func get_voxel(pos: Vector3i) -> Voxel:
	return voxels.get(pos % size)


func has_voxel(pos: Vector3i) -> bool:
	return voxels.has(pos % size)


func commit() -> void:
	mesh.commit()
	
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh.arrays)
	array_mesh.surface_set_material(0, material)
	
	mesh_instance_3d.mesh = array_mesh
	collision_shape_3d.shape = array_mesh.create_trimesh_shape()


class ChunkMesh:
	var arrays: Array = []
	var vertices := PackedVector3Array()
	var normals := PackedVector3Array()
	var colors := PackedColorArray()
	
	
	func add_face(pos: Vector3i, model: VoxelModel, face: Voxel.Face) -> void:
		vertices.append_array(model.get_vertices(face, pos))
		normals.append_array(model.get_normals(face))
		colors.append_array(model.get_colors(face))
	
	
	func commit() -> void:
		arrays.resize(Mesh.ARRAY_MAX)
		arrays[Mesh.ARRAY_VERTEX] = vertices
		arrays[Mesh.ARRAY_NORMAL] = normals
		arrays[Mesh.ARRAY_COLOR] = colors
