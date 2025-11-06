extends EntityBase
class_name SummonBase

@export var attraction: float = 0.0

var myMaster: EntityBase = null

func _ready():
	super._ready()
	for entity in get_tree().get_nodes_in_group("mobs"):
		var ent = entity as EntityBase
		if MathTool.rate(attraction):
			ent.currentFocusedBoss = self
