class_name ChunkManager
extends Node


const CHUNK = preload("uid://du16hg66uur71")

@export var colors: Array[Color]
@export var dimensions := Vector3i(128, 64, 128)
@export var chunk_size: int = 32
@export var noise_seed: int = 0

var random := FastNoiseLite.new()
var number_of_chunks: Vector3

var loading_threads: Array[Thread] = [Thread.new(), Thread.new(), Thread.new(), Thread.new()]


func _ready() -> void:
	random.noise_type = FastNoiseLite.TYPE_SIMPLEX
	random.frequency = 0.003
	random.seed = noise_seed
	
	@warning_ignore("integer_division")
	number_of_chunks = dimensions / chunk_size
	
	loading_threads[0].start(generate_chunks.bind(Vector3(0, 0, 0)))
	loading_threads[1].start(generate_chunks.bind(Vector3(dimensions.x / 2.0, 0, 0)))
	loading_threads[2].start(generate_chunks.bind(Vector3(0, 0, dimensions.z / 2.0)))
	loading_threads[3].start(generate_chunks.bind(Vector3(dimensions.x / 2.0, 0, dimensions.z / 2.0)))


func generate_chunks(pos: Vector3) -> void:
	var chunks: Vector3 = number_of_chunks / 2
	for x in range(chunks.x):
		for z in range(chunks.z):
			for y in range(number_of_chunks.y):
				var chunk: Chunk = CHUNK.instantiate()
				chunk.position = Vector3(x, y, z) * chunk_size + pos
				chunk.generate_data(chunk_size, dimensions.y, random, colors)
				chunk.generate_mesh()
				call_deferred("add_child", chunk)


func _exit_tree() -> void:
	for thread in loading_threads:
		thread.wait_to_finish()
