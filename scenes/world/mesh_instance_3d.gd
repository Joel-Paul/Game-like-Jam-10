extends MeshInstance3D


@export var mat: Material

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

@onready var collision_shape_3d: CollisionShape3D = $StaticBody3D/CollisionShape3D


func _ready() -> void:
	surface_array.resize(Mesh.ARRAY_MAX)


func generate_mesh(data: Dictionary[Vector3, Color]) -> void:
	for pos in data:
		var color = data[pos]
		for face in Face.values():
			if not has_neighbour(data, face, pos):
				add_face(face, pos, color)
	commit_mesh()


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
	
	(mesh as ArrayMesh).add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	mesh.surface_set_material(0, mat)
	
	collision_shape_3d.shape = mesh.create_trimesh_shape()
