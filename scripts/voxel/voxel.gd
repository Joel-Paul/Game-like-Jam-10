class_name Voxel
extends Resource
## Represents the voxel cube.


## The face of the voxel.
enum Face { FRONT, BACK, LEFT, RIGHT, TOP, BOTTOM }

## Visual of the voxel.
var model: VoxelModel
## Set transparency to ensure rendering and culling work properly.
var is_transparent := false


func _init(voxel_model: VoxelModel) -> void:
	model = voxel_model


## Set transparency to ensure rendering and culling work properly.
func set_transparent(transparent := true) -> Voxel:
	is_transparent = transparent
	return self
