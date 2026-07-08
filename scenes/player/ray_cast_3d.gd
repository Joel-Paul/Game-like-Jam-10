class_name VoxelCast
extends RayCast3D
## Find the grid-aligned position of the
## focused voxel, and where they can be placed.
##
## The place position is just on the side of the currently focused voxel.


## Get a [VoxelCast.RayHit] object which carries the position where a
## voxel can be placed, and the position of the focused voxel.
func get_voxel() -> RayHit:
	if not get_collider() is Chunk:
		return null
	
	var point: Vector3 = get_collision_point()
	var normal: Vector3 = get_collision_normal()
	var pos: Vector3 = (point - normal / 2).floor()
	
	return RayHit.new(pos + normal, pos)


## Helper class to package the position of places we can
## place the voxel at and the position of the focused voxel.
class RayHit:
	## The position where a new voxel will be placed.
	var place_position: Vector3i
	## The position of the focused voxel.
	var break_position: Vector3i
	
	
	## [param place_pos] denotes the position to place the new voxel.
	## [param break_pos] denotes the position of the currently focused voxel.
	func _init(place_pos: Vector3i, break_pos: Vector3i) -> void:
		place_position = place_pos
		break_position = break_pos
