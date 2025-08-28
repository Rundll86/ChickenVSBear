class_name ArrayTool

static func removeAll(array: Array, value) -> Array:
    var result = []
    for item in array:
        if item != value:
            result.append(item)
    return result