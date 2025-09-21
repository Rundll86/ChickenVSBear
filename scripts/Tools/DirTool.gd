class_name DirTool

static func listdir(path: String) -> Array[String]:
	var files: Array[String] = []
	var dir = DirAccess.open(path)
	if !path.ends_with("/"):
		path += "/"
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				if file_name.get_extension() == "remap":
					file_name = file_name.substr(0, len(file_name) - 6)
				files.append(path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
		return files
	else:
		return []
