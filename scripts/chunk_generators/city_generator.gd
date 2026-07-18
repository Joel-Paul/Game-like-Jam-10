class_name CityGenerator
extends ChunkGenerator


@export var skyscraper_width: int = 32
@export var skyscraper_spacing: int = 16

@export var window_size := Vector2i(2, 3)
@export var window_spacing := Vector2i(3, 3)

@export var ground_level: int = 4


func setup() -> void:
	skyscraper_spacing += skyscraper_width
	window_spacing += window_size


func generate(chunk: Chunk) -> void:
	for x in range(chunk.size.x):
		for y in range(chunk.size.y):
			for z in range(chunk.size.z):
				var pos := Vector3i(x, y, z)
				var global_pos := Vector3i(chunk.position) + pos
				var voxel: Voxel
				if global_pos.y <= chunk.manager.min_height + ground_level:
					voxel = Voxels.stone
				else:
					voxel = _skyscraper(global_pos)
				if voxel:
					chunk.voxels[pos] = voxel


func _skyscraper(global_pos: Vector3i) -> Voxel:
	var skyscraper_pos := global_pos % skyscraper_spacing
	skyscraper_pos.y = global_pos.y
	
	var x_wall: bool = skyscraper_pos.x in [0, skyscraper_width - 1] \
			and skyscraper_pos.z < skyscraper_width
	var z_wall: bool = skyscraper_pos.z in [0, skyscraper_width - 1] \
			and skyscraper_pos.x < skyscraper_width
	
	if x_wall or z_wall:
		var window_pos := skyscraper_pos % Vector3i(window_spacing.x, window_spacing.y, window_spacing.x)
		var x_window: bool = window_pos.x < window_size.x
		var y_window: bool = window_pos.y < window_size.y
		var z_window: bool = window_pos.z < window_size.x
		var window: bool = x_window and y_window and z_window
		return Voxels.glass if window else Voxels.stone
		
	return null
