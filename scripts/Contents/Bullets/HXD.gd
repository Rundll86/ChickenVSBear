extends BulletBase
class_name HXDBullet

var bouncedTime: int = 0
var maxBouncedTime: int = 0
var lastHit: EntityBase
var addTimes = 0
var delta = 0.05

func spawn():
	texture.play(str(randi_range(0, 2)))
func ai():
	PresetBulletAI.forward(self, rotation)
func destroy(_beacuseMap: bool):
	launcher.fields[FieldStore.Entity.DAMAGE_MULTIPILER] -= addTimes * delta
func succeedToHit(_dmg: float, entity: EntityBase):
	if entity.isBoss:
		launcher.fields[FieldStore.Entity.ATTACK_SPEED] += delta
		addTimes += 1
	if is_instance_valid(lastHit):
		if lastHit.get_class() == entity.get_class():
			entity.bulletHit(self, true)
	lastHit = entity
	if bouncedTime < maxBouncedTime:
		var newEntity = EntityTool.findClosetEntity(position, get_tree(), !launcher.isPlayer(), launcher.isPlayer(), [entity])
		if is_instance_valid(newEntity):
			look_at(newEntity.getTrackingAnchor())
			if !MathTool.rate(0.25):
				bouncedTime += 1
	var effect = EffectController.create(ComponentManager.getEffect("HXDBoom"), position)
	effect.particles.texture = load("res://resources/bullets/HXD/effect/%d.png" % randi_range(0, 4))
	effect.shot()
func split(newBullet: BulletBase, _index: int, _total: int, _lastBullet: float):
	if newBullet is HXDBullet:
		newBullet.bouncedTime = 0
	return newBullet
func refract(newBullet: BulletBase, _entity: EntityBase, _index: int, _total: int, _lastBullet: float):
	if newBullet is HXDBullet:
		newBullet.bouncedTime = 0
	return newBullet
