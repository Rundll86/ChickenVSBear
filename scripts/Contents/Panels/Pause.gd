@tool
extends FullscreenPanelBase

@onready var aboutBtn: Button = $"%aboutBtn"

func _ready():
	aboutBtn.pressed.connect(
		func():
			UIState.setPanel("Thanks")
	)
