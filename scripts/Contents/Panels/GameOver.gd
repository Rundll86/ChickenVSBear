@tool
extends FullscreenPanelBase

@onready var audio = $"%audio"

func beforeOpen():
	audio.play()
