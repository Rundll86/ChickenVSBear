extends SummonBase

var attackTime: float = 0
var tracer: EntityBase = null

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 150
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 1.5
	await TickTool.frame()
	attackCooldownMap[0] = attackTime
func spawn():
	texture.play("walk")
func ai():
	tryAttack(0)
	if is_instance_valid(tracer):
		PresetEntityAI.follow(self, tracer, 80)
	else:
		tracer = EntityTool.findClosetEntity(position, get_tree(), !isPlayer(), isPlayer())
func attack(type):
	if type == 0:
		for bullet in BulletBase.generate(
			ComponentManager.getBullet("HJMAttack"),
			self,
			findWeaponAnchor("normal"),
			0
		):
			bullet.damage = atk
