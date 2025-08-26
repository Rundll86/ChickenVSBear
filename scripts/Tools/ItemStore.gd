@tool
class_name ItemStore

enum ItemType {
	BASEBALL,
	BASKETBALL
}
static var nameMap = {
	ItemType.BASEBALL: "棒球",
	ItemType.BASKETBALL: "篮球"
}
static var idMap = {
	ItemType.BASEBALL: "baseball",
	ItemType.BASKETBALL: "basketball"
}
static func getTexture(type: ItemType) -> Texture2D:
	return load("res://resources/items/%s.svg" % idMap[type])