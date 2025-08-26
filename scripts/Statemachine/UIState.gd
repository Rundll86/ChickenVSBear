extends CanvasLayer
class_name UIState

static var bossbar: EntityStateBar

func _ready():
	bossbar = $"%bossbar"
func _process(_delta):
	bossbar.visible = !!bossbar.entity
