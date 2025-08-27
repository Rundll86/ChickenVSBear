@tool
class_name ItemStore

enum ItemType {
	BASEBALL,
	BASKETBALL,
	APPLE
}
static var nameMap = {
	ItemType.BASEBALL: "棒球",
	ItemType.BASKETBALL: "篮球",
	ItemType.APPLE: "苹果"
}
static var idMap = {
	ItemType.BASEBALL: "baseball",
	ItemType.BASKETBALL: "basketball",
	ItemType.APPLE: "apple"
}
static func getTexture(type: ItemType) -> Texture2D:
	return load("res://resources/items/%s.svg" % idMap[type])
