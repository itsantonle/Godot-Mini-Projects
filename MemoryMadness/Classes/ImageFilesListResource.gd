extends Resource

class_name ImageFilesResource 

@export var file_names: Array[String]

func add_file(fn: String) -> void: 
	if !fn.ends_with(".import"): 
		file_names.append(fn)
