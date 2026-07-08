class_name Voxel
extends Resource


enum Face { FRONT, BACK, LEFT, RIGHT, TOP, BOTTOM }

var model: VoxelModel
var is_transparent := false


func _init(voxel_model: VoxelModel) -> void:
	model = voxel_model


func set_transparent(transparent := true) -> Voxel:
	is_transparent = transparent
	return self
