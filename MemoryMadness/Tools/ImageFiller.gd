@tool
extends EditorScript
# this is intended to run inside the editor (scripts for doing something automated)  always put the decoartor on top

#read from this path 
const PATH: String = "res://assets/glitch/"
#save in this path 
const RES_PATH: String = "res://Resources/image_files_list.tres"

# default function when script is execurted 
func _run() -> void:
	# open path in directory 
	var dir: DirAccess = DirAccess.open(PATH)
	var ifl: ImageFilesResource = ImageFilesResource.new()
	
	if dir: 
		# retyrns all filenames in dir
		var files: PackedStringArray = dir.get_files()
		for fileName in files: 
			ifl.add_file(PATH + fileName)
			# this saves as "res://assets/glitch/something.png" 
		ResourceSaver.save(ifl, RES_PATH)
