@tool
class_name ItemStore

enum ItemType {
	BASEBALL,
	BASKETBALL,
	APPLE,
	BEACHBALL,
	SOUL,
}
static var nameMap = {
	ItemType.BASEBALL: "棒球",
	ItemType.BASKETBALL: "篮球",
	ItemType.APPLE: "苹果",
	ItemType.BEACHBALL: "沙滩球",
	ItemType.SOUL: "灵魂",
}
static var idMap = {
	ItemType.BASEBALL: "baseball",
	ItemType.BASKETBALL: "basketball",
	ItemType.APPLE: "apple",
	ItemType.BEACHBALL: "beachball",
	ItemType.SOUL: "soul",
}
static func getTexture(type: ItemType) -> Texture2D:
	return ComponentManager.getItemTexture(idMap.get(type, "baseball"))
