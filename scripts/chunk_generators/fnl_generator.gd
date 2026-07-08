class_name FNLGenerator
extends ChunkGenerator
## Generator that uses [FastNoiseLite] as the basis for generation.


## See [member FastNoiseLite.frequency]
@export var frequency: float = 0.01
## See [member FastNoiseLite.noise_type]
@export var noise_type := FastNoiseLite.TYPE_SIMPLEX_SMOOTH
## See [member FastNoiseLite.seed]
@export var noise_seed: int = 0

## The [FastNoiseLite] instance.
var fnl := FastNoiseLite.new()


func setup() -> void:
	fnl.frequency = frequency
	fnl.noise_type = noise_type
	fnl.seed = noise_seed


func generate(chunk: Chunk) -> void:
	for x in range(chunk.size.x):
		for y in range(chunk.size.y):
			for z in range(chunk.size.z):
				var pos := Vector3i(x, y, z)
				var global_pos := Vector3i(chunk.position) + pos
				var rand: float = fnl.get_noise_3d(global_pos.x, global_pos.y, global_pos.z)
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
