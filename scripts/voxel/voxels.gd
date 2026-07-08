class_name Voxels
extends Resource


static var grass: Voxel
static var dirt: Voxel
static var stone: Voxel
static var magma: Voxel
static var glass: Voxel


static func load_voxels() -> void:
	grass = Voxel.new(CubeModel.new(Color.DARK_GREEN)
		.set_texture(Voxel.Face.TOP, "grass")
		.set_texture(Voxel.Face.BOTTOM, "dirt")
		.set_texture_sides("grass_side"))
	dirt = Voxel.new(CubeModel.new(Color.SIENNA).set_texture_all("dirt"))
	stone = Voxel.new(CubeModel.new(Color.DIM_GRAY).set_texture_all("stone"))
	magma = Voxel.new(CubeModel.new(Color.ORANGE_RED).set_texture_all("magma"))
	glass = Voxel.new(CubeModel.new(Color.ORANGE_RED).set_texture_all("glass"))
