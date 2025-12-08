class_name PresetSummonAI

static func lockMaster(summon: SummonBase, myMaster: EntityBase, onTexture: bool = false) -> void:
	if onTexture:
		summon.position = myMaster.texture.global_position
	else:
		summon.position = myMaster.position
