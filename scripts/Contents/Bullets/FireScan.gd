extends BulletBase
class_name FireScan

func _ready():
	fields[FieldStore.Bullet.SPEED] = 5
	fields[FieldStore.Bullet.DAMAGE] = 20
	super._ready()

func ai():
	forward(Vector2.from_angle(rotation))
