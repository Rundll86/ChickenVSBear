extends BulletBase

func ai():
	PresetBulletAI.forward(self, rotation)
	if position.y > CameraManager.instance.position.y + QuickUI.getWindowSize().y / 2:
		tryDestroy()
