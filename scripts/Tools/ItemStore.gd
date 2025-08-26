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