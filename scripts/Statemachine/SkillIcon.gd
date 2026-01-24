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
		var progress = min(weapon.cooldownTimer.percent(), UIState.player.fillingProgress(weapon.needEnergy))
		material.set_shader_parameter("progress", progress)
		particle.emitting = progress >= 1
		if progress >= 1:
			if !showed:
				showed = true
		else:
			showed = false
