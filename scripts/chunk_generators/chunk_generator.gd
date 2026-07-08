@abstract
class_name ChunkGenerator
extends Resource
## Algorithm used to generate chunks.

## Runs once when the game is loaded. Used to set up any exported variables.
func setup() -> void:
	pass


## Generate this [param chunk].
@abstract func generate(chunk: Chunk) -> void
