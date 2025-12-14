extends BulletBase
class_name MushroomPickaxe

var count: int = 2
var rate: float = 0.1

func succeedToHit(_dmg, entity):
	if MathTool.rate(rate):
		for i in randi_range(1, count):
			ItemDropped.generate(
				MathTool.randomChoiceFrom([ItemStore.ItemType.BASEBALL, ItemStore.ItemType.BASKETBALL, ItemStore.ItemType.BEACHBALL]),
				randi_range(1, count),
				entity.position + MathTool.randomVector2In(GameRule.itemDroppedSpawnOffset)
			)
