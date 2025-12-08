extends SummonBase
class_name ShieldSummon

func register():
	fields[FieldStore.Entity.PENARATION_RESISTANCE] = 1.0
func ai():
	PresetSummonAI.lockMaster(self, myMaster, true)
