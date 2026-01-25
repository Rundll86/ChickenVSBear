@tool
extends FullscreenPanelBase

func afterOpen(_args: Array = []):
	for key in ComponentManager.effects:
		var effect = EffectController.create(ComponentManager.getEffect(key), Vector2.ZERO, self)
		effect.modulate.a = 0.01
		(effect.sounds.get_node("spawn") as AudioStreamPlayer2D).volume_db = - INF
		effect.shot()
	await TickTool.millseconds(3000)
	UIState.closeCurrentPanel()
