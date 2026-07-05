class_name Voxel
extends Resource


enum Face { FRONT, BACK, LEFT, RIGHT, TOP, BOTTOM }

var model: VoxelModel


func _init(voxel_model: VoxelModel) -> void:
	model = voxel_model
