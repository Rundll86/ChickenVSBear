class_name JsonTool

static func parseJson(filePath: String):
	var file = FileAccess.open(filePath, FileAccess.READ)
	var json = file.get_as_text()
	file.close()
	var jsonObj = JSON.new()
	jsonObj.parse(json)
	return jsonObj.data
