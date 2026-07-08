extends Node
## Global script to load textures and create a [Texture2DArray].


## Folder path to voxel textures.
const TEXTURE_PATH = "res://assets/voxels/"

## Stores the voxel textures which are then used by the [Chunk] mesh.
var texture_array := Texture2DArray.new()
## Maps a human readable name to a texture index.
## The name is taken from the filename of the image.
var texture_map: Dictionary[StringName, int] = {}


func _ready() -> void:
	var image_array: Array[Image] = []
	var texture_files: PackedStringArray = ResourceLoader.list_directory(TEXTURE_PATH)
	
	for file: String in texture_files:
		if not file.ends_with(".png"):
			return
		
		var path: String = TEXTURE_PATH.path_join(file)
		var texture: Resource = ResourceLoader.load(path, "CompressedTexture2D")
		if texture is not CompressedTexture2D:
			return
		
		var image = texture.get_image()
		image.convert(Image.Format.FORMAT_RGBA8)
		image_array.append(image)
		texture_map[file.get_basename()] = texture_map.size()
	
	texture_array.create_from_images(image_array)
	RenderingServer.global_shader_parameter_set("texture_array", texture_array)
	# Load voxels once textures are all defined.
	Voxels.load_voxels()
