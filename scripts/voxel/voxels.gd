class_name Voxels
extends Resource
## Stores static references to all the voxels in the game.


static var grass: Voxel
static var dirt: Voxel
static var stone: Voxel
static var magma: Voxel
static var glass: Voxel


## Set the properties and textures for each voxel.
static func load_voxels() -> void:
	grass = Voxel.new(CubeModel.new()
		.set_texture(Voxel.Face.TOP, "grass")
		.set_texture(Voxel.Face.BOTTOM, "dirt")
		.set_texture_sides("grass_side"))
	dirt = Voxel.new(CubeModel.new().set_texture_all("dirt"))
	stone = Voxel.new(CubeModel.new().set_texture_all("stone"))
	magma = Voxel.new(CubeModel.new().set_texture_all("magma"))
	glass = Voxel.new(CubeModel.new().set_texture_all("glass")) \
			.set_transparent()
