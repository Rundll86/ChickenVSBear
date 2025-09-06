extends PanelContainer
class_name SkillIcon

@export var weapon: Weapon = null;

@onready var textureRect = $"%texture"

func _physics_process(_delta):
	if is_instance_valid(weapon):
		textureRect.texture = weapon.avatarTexture
		textureRect.material.set_shader_parameter("progress", clamp(weapon.cooldownTimer.timeSinceLastStart() / weapon.cooldownTimer.cooldown, 0, 1))
