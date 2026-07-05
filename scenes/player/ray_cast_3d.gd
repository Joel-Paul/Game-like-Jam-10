class_name VoxelCast
extends RayCast3D


func get_voxel() -> RayHit:
	if not get_collider() is Chunk:
		return null
	
	var point: Vector3 = get_collision_point()
	var normal: Vector3 = get_collision_normal()
	var pos: Vector3 = (point - normal / 2).floor()
	
	return RayHit.new(pos + normal, pos)


class RayHit:
	var place_position: Vector3i
	var break_position: Vector3i
	
	
	func _init(place_pos: Vector3i, break_pos: Vector3i) -> void:
		place_position = place_pos
		break_position = break_pos
