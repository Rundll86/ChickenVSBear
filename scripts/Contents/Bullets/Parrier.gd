extends BulletBase
class_name ParrierBullet

@export var parryRate: float = 1

var parryiedTimes: int = 0
var maxParryTimes: int = 1
var maxBallCount: int = 3
var atk: float = 0

func spawn():
	var varians = randi_range(0, 2)
	var inverts = [2]
	var frames = load("res://resources/effects/parrier/%d/%d.tres" % [varians, varians])
	var eff = EffectController.create(ComponentManager.getEffect("Parrier"), position)
	eff.rotation = rotation
	eff.texture.scale.y *= MathTool.randomChoiceFrom([-1, 1])
	if varians in inverts:
		eff.texture.scale.x *= -1
	eff.texture.sprite_frames = frames
	eff.shot()
func hitBullet(bullet: BulletBase): # 当前子弹与其他子弹相撞
	if BulletTool.canDamage(bullet, launcher): # 其他子弹可以使当前子弹的发射者受伤吗？
		if parryiedTimes < maxParryTimes && MathTool.rate(parryRate): # 一个刀光最多格挡多少个敌方子弹？
			parryiedTimes += 1
			# 生成格挡特效
			var eff = EffectController.create(ComponentManager.getEffect("Parry"), position + (bullet.position - position).normalized() * 200) # 从子弹位置，面向其他子弹的方向前进150
			eff.modulate = bullet.modulate.blend(bullet.texture.modulate)
			eff.shot()
			# 摧毁其他子弹
			bullet.tryDestroy()
			var cycler = launcher.getOrCreateCycleTimer("parry", 2000, 100)
			if len(cycler.bullets) < maxBallCount: # 玩家最多只能拥有5点气
				for b in BulletBase.generate(
					ComponentManager.getBullet("ParryBall"), # 生成气的子弹
					launcher,
					position,
					0
				):
					if b is ParryBallBullet:
						b.atk = atk * bullet.baseDamage
func refract(_newBullet: BulletBase, _entity: EntityBase, _index: int, _total: int, _lastBullet: float):
	return null
func split(_newBullet: BulletBase, _index: int, _total: int, _lastBullet: float):
	return null
