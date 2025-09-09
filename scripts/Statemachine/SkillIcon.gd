extends PanelContainer
class_name SkillIcon

@export var weapon: Weapon = null;

@onready var textureRect: TextureRect = $"%texture"
func _ready():
	material = material.duplicate()
func _physics_process(_delta):
	if is_instance_valid(weapon):
		textureRect.texture = weapon.avatarTexture
		var progress = min(weapon.cooldownTimer.timeSinceLastStart() / weapon.cooldownTimer.cooldown, UIState.player.energy / weapon.needEnergy)
		material.set_shader_parameter("progress", progress)
