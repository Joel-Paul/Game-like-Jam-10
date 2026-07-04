class_name OddGenerator
extends ChunkGenerator


func generate(chunk: Chunk) -> void:
	for x in range(chunk.size.x):
		for y in range(chunk.size.y):
			for z in range(chunk.size.z):
				var pos := Vector3i(x, y, z) + Vector3i(chunk.position) * chunk.size
				if pos.x % 2 == 0:
					pass
