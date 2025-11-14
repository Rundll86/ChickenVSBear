class_name ArrayTool

static func removeAll(array: Array, value) -> Array:
	var result = []
	for item in array:
		if item != value:
			result.append(item)
	return result
static func swap(array: Array, a: int, b: int):
	var temp = array[a]
	array[a] = array[b]
	array[b] = temp
	return array
static func parseEncodedObject(arr: Array) -> Array:
	var result = []
	for item in arr:
		if item is EncodedObjectAsID:
			result.append(instance_from_id(item.get_instance_id()))
		else:
			result.append(item)
	return result
