class_name Chunk
extends StaticBody3D


const _CHUNK = preload("uid://du16hg66uur71")

var voxels: Dictionary[Vector3, Color] = {}
var size: Vector3i

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D


static func create(chunk_pos: Vector3i, chunk_size: Vector3i) -> Chunk:
	var chunk: Chunk = _CHUNK.instantiate()
	chunk.position = chunk_pos
	chunk.size = chunk_size
	return chunk


#func _ready() -> void:
	#if voxels.is_empty():
		#return
	#surface_array.resize(Mesh.ARRAY_MAX)
	#commit_mesh()


#func has_neighbour(face: Face, pos: Vector3) -> bool:
	#var neighbour_position = pos + face_normals[face]
	#return voxels.has(neighbour_position)
#
#
#func add_face(face: Face, pos: Vector3, color: Color) -> void:
	#var indicies = face_indicies[face]
	#for triangle in indicies:
		#for index in triangle:
			#vertices.append(cube_vertices[index] + pos)
			#normals.append(face_normals[face])
			#colors.append(color)
#
#
#func commit_mesh() -> void:
	#surface_array[Mesh.ARRAY_VERTEX] = vertices
	#surface_array[Mesh.ARRAY_NORMAL] = normals
	#surface_array[Mesh.ARRAY_COLOR] = colors
	#
	#var array_mesh := ArrayMesh.new()
	#array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	#mesh_instance_3d.mesh = array_mesh
	#mesh_instance_3d.mesh.surface_set_material(0, mat)
	#collision_shape_3d.shape = mesh_instance_3d.mesh.create_trimesh_shape()
