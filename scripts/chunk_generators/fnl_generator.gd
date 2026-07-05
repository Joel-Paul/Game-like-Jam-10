class_name FNLGenerator
extends ChunkGenerator


@export var frequency: float = 0.01
@export var noise_type := FastNoiseLite.TYPE_SIMPLEX_SMOOTH
@export var noise_seed: int = 0

var noise := FastNoiseLite.new()


func setup() -> void:
	noise.frequency = frequency
	noise.noise_type = noise_type
	noise.seed = noise_seed


func generate(chunk: Chunk) -> void:
	for x in range(chunk.size.x):
		for y in range(chunk.size.y):
			for z in range(chunk.size.z):
				var pos := Vector3i(x, y, z)
				var global_pos := Vector3i(chunk.position) + pos
				var rand: float = noise.get_noise_3d(global_pos.x, global_pos.y, global_pos.z)
				var voxel: Voxel
				if rand > 0:
					if global_pos.y == chunk.manager.max_height:
						voxel = Voxels.grass
					elif global_pos.y >= chunk.manager.max_height - 5:
						voxel = Voxels.dirt
					else:
						voxel = Voxels.stone
				elif global_pos.y <= chunk.manager.min_height + 5:
					voxel = Voxels.magma
				if voxel:
					chunk.voxels[pos] = voxel
