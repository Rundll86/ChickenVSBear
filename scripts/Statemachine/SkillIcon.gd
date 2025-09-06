extends PanelContainer
class_name SkillIcon

@export var weapon: Weapon = null;

@onready var textureRect: TextureRect = $"%texture"

func _ready():
	textureRect.material = textureRect.material.duplicate()
func _physics_process(_delta):
	if is_instance_valid(weapon):
		textureRect.texture = weapon.avatarTexture
		var progress = weapon.cooldownTimer.timeSinceLastStart() / weapon.cooldownTimer.cooldown
		textureRect.material.set_shader_parameter("progress", progress)
