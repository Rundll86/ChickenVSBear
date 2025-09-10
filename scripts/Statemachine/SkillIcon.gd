extends PanelContainer
class_name SkillIcon

@export var weapon: Weapon = null;

@onready var textureRect: TextureRect = $"%texture"
@onready var particle: GPUParticles2D = $"%particle"

var showed: bool = false

func _ready():
	material = material.duplicate()
func _physics_process(_delta):
	if is_instance_valid(weapon):
		textureRect.texture = weapon.avatarTexture
		var progress = min(weapon.cooldownTimer.timeSinceLastStart() / weapon.cooldownTimer.cooldown, UIState.player.energy / weapon.needEnergy)
		material.set_shader_parameter("progress", progress)
		if progress >= 1:
			if !showed:
				showed = true
				particle.emitting = true
		else:
			showed = false
