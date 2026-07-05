class_name OddGenerator
extends ChunkGenerator


func generate(chunk: Chunk) -> void:
	for x in range(chunk.size.x):
		for y in range(chunk.size.y):
			for z in range(chunk.size.z):
				var pos := Vector3i(x, y, z)
				if x % 2:
					chunk.voxels[pos] = Voxels.dirt
				else:
					chunk.voxels[pos] = Voxels.stone
