class_name DirTool

static func listdir(path: String) -> Array[String]:
	var files: Array[String] = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				files.append(path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
		return files
	else:
		return []
