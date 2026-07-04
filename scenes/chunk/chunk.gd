class_name Chunk
extends StaticBody3D


@export var mat: Material

var voxels: Dictionary[Vector3, Color] = {}

var surface_array: Array = []
var vertices := PackedVector3Array()
var normals := PackedVector3Array()
var colors := PackedColorArray()

var cube_vertices: Array[Vector3] = [
	Vector3(-0.5, -0.5, 0.5),
	Vector3(0.5, -0.5, 0.5),
	Vector3(0.5, -0.5, -0.5),
	Vector3(-0.5, -0.5, -0.5),
	Vector3(-0.5, 0.5, 0.5),
	Vector3(0.5, 0.5, 0.5),
	Vector3(0.5, 0.5, -0.5),
	Vector3(-0.5, 0.5, -0.5),
]

enum Face { BOTTOM, FRONT, RIGHT, TOP, LEFT, BACK }

var face_indicies: Dictionary[Face, Array] = {
	Face.FRONT: [[0, 4, 5], [0, 5, 1]],
	Face.BACK: [[2, 7, 3], [2, 6, 7]],
	Face.LEFT: [[3, 7, 4], [3, 4, 0]],
	Face.RIGHT: [[1, 5, 6], [1, 6, 2]],
	Face.TOP: [[4, 7, 6], [4, 6, 5]],
	Face.BOTTOM: [[0, 1, 2], [0, 2, 3]],
}

var face_normals: Dictionary[Face, Vector3] = {
	Face.FRONT: Vector3.MODEL_FRONT,
	Face.BACK: Vector3.MODEL_REAR,
	Face.LEFT: Vector3.LEFT,
	Face.RIGHT: Vector3.RIGHT,
	Face.BOTTOM: Vector3.MODEL_BOTTOM,
	Face.TOP: Vector3.MODEL_TOP,
}

var face_colors: Dictionary[Face, Color] = {
	Face.FRONT: Color.ORANGE,
	Face.BACK: Color.PURPLE,
	Face.LEFT: Color.BLUE,
	Face.RIGHT: Color.YELLOW,
	Face.BOTTOM: Color.RED,
	Face.TOP: Color.GREEN,
}

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D


func _ready() -> void:
	surface_array.resize(Mesh.ARRAY_MAX)
	mesh_instance_3d.mesh = ArrayMesh.new()
	if voxels.is_empty():
		return
	commit_mesh()


func generate_data(chunk_size: int, max_height: int, noise: Noise, color_array: Array[Color]) -> void:
	for x in range(chunk_size):
		for z in range(chunk_size):
			var global_pos = position + Vector3(x, 0, z)
			var rand = ((noise.get_noise_2d(global_pos.x, global_pos.z) \
					+ 0.5 * noise.get_noise_2d(global_pos.x * 2, global_pos.z * 2) \
					+ 0.25 * noise.get_noise_2d(4 * global_pos.x, 4 * global_pos.z)) / 1.75 \
					+ 1) \
					/ 2
			var rand_p = pow(rand, 2.1)
			var height = max_height * rand_p
			
			if height < position.y:
				continue
			
			var local_height = height - position.y
			for y in range(min(local_height, chunk_size)):
				voxels[Vector3(x, y, z)] = color_array[y % color_array.size()]


func generate_mesh() -> void:
	if voxels.is_empty():
		return
	for pos in voxels:
		var color = voxels[pos]
		for face in Face.values():
			if not has_neighbour(voxels, face, pos):
				add_face(face, pos, color)


func has_neighbour(data: Dictionary[Vector3, Color], face: Face, pos: Vector3) -> bool:
	var neighbour_position = pos + face_normals[face]
	return data.has(neighbour_position)


func add_face(face: Face, pos: Vector3, color: Color) -> void:
	var indicies = face_indicies[face]
	for triangle in indicies:
		for index in triangle:
			vertices.append(cube_vertices[index] + pos)
			normals.append(face_normals[face])
			colors.append(color)


func commit_mesh() -> void:
	surface_array[Mesh.ARRAY_VERTEX] = vertices
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_COLOR] = colors
	
	(mesh_instance_3d.mesh as ArrayMesh).add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	mesh_instance_3d.mesh.surface_set_material(0, mat)
	
	collision_shape_3d.shape = mesh_instance_3d.mesh.create_trimesh_shape()
