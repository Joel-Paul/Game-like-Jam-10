extends Node


const TEXTURE_PATH = "res://assets/voxels/"

var texture_array := Texture2DArray.new()
var texture_map: Dictionary[StringName, int] = {}


func _ready() -> void:
	var image_array: Array[Image] = []
	var texture_files: PackedStringArray = ResourceLoader.list_directory(TEXTURE_PATH)
	for file: String in texture_files:
		if file.ends_with(".png"):
			var path: String = TEXTURE_PATH.path_join(file)
			var texture: Resource = ResourceLoader.load(path, "CompressedTexture2D")
			if texture is CompressedTexture2D:
				var image = texture.get_image()
				image.convert(Image.Format.FORMAT_RGBA8)
				image_array.append(image)
				texture_map[file.get_basename()] = texture_map.size()
	texture_array.create_from_images(image_array)
	RenderingServer.global_shader_parameter_set("texture_array", texture_array)
	Voxels.load_voxels()
