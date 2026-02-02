extends BulletBase
class_name HXDBullet

var bouncedTime: int = 0
var maxBouncedTime: int = 0

func spawn():
	texture.play(str(randi_range(0, 2)))
func ai():
	PresetBulletAI.forward(self, rotation)
func succeedToHit(_dmg: float, entity: EntityBase):
	if bouncedTime < maxBouncedTime:
		var newEntity = EntityTool.findClosetEntity(position, get_tree(), !launcher.isPlayer(), launcher.isPlayer(), [entity])
		if is_instance_valid(newEntity):
			look_at(newEntity.position)
			bouncedTime += 1
		EffectController.create(ComponentManager.getEffect("HXDBoom"), position).shot()
func split(newBullet: BulletBase, _index: int, _total: int, _lastBullet: float):
	if newBullet is HXDBullet:
		newBullet.bouncedTime = 0
	return newBullet
func refract(newBullet: BulletBase, _entity: EntityBase, _index: int, _total: int, _lastBullet: float):
	if newBullet is HXDBullet:
		newBullet.bouncedTime = 0
	return newBullet
