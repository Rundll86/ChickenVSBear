extends BulletBase
class_name AcidStormBullet

var acids: Array[String] = ["AcidS", "AcidN", "AcidCl", "AcidP", "AcidC"]

var strongAtk: float = 0
var weakAtk: float = 0
var sCountMax: int = 0
var nAtk: float = 0
var clSpeed: float = 0
var clAtkSpeed: float = 0
var cAtk: float = 0
var pOffset: float = 0
var f: float = 0

func ai():
	PresetBulletAI.forward(self , rotation)
func applyDot():
	var acid = MathTool.randomChoiceFrom(acids)
	for bullet in BulletBase.generate(
		ComponentManager.getBullet(acid),
		launcher,
		position,
		0,
	):
		if bullet is AcidBulletBase:
			bullet.storm = self
			if bullet.acidType == AcidBulletBase.AcidType.STRONG:
				bullet.baseDamage = strongAtk
			else:
				bullet.baseDamage = weakAtk
			if bullet is AcidS:
				bullet.arg1 = sCountMax
			if bullet is AcidN:
				bullet.arg1 = nAtk
			if bullet is AcidCl:
				bullet.arg1 = clSpeed
				bullet.arg2 = clAtkSpeed
			if bullet is AcidP:
				bullet.arg1 = pOffset
				bullet.arg2 = EntityTool.findClosetEntity(get_global_mouse_position(), get_tree(), !launcher.isPlayer(), launcher.isPlayer())
			if bullet is AcidC:
				bullet.arg1 = cAtk
	await TickTool.millseconds(1000.0 / f)
	return true
