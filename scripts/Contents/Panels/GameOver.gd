@tool
extends FullscreenPanelBase

@onready var audio = $"%audio"
@onready var deadreason = $"%deadreason"

func beforeOpen():
	audio.play()
