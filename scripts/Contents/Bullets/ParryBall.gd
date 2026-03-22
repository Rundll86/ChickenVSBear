extends BulletBase
class_name ParryBallBullet

var cycler: CycleTimer
var atk: float = 0

func spawn():
	cycler = launcher.getOrCreateCycleTimer("parry")
	cycler.host(self )
	launcher.sprintMultiplier += 1
func destroy(_beacuseMap: bool):
	launcher.sprintMultiplier -= 1
func ai():
	PresetBulletAI.selfRotate(self , 5)
	hitbox.disabled = !launcher.sprinting # 玩家在冲刺时气的碰撞箱才生效
	hitbox.global_position = launcher.position
func succeedToHit(_dmg: float, entity: EntityBase): # 当撞到敌人时
	for bullet in BulletBase.generate(
		ComponentManager.getBullet("QKSword"),
		launcher,
		entity.position,
		0
	):
		if bullet is QKSwordBullet:
			bullet.baseDamage = atk
			bullet.position = entity.texture.global_position + MathTool.sampleInRing(200, 500)
			bullet.tracer = entity
			bullet.look_at(entity.getTrackingAnchor()) # 生成的乾坤剑面向敌人
