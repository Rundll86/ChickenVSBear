@tool
extends FullscreenPanelBase

@onready var diffEdit: HSlider = $"%diffEdit"
@onready var startBtn: Button = $"%startBtn"
@onready var levelShow: Label = $"%levelShow"

func _ready():
	startBtn.pressed.connect(
		func():
			Wave.next()
			UIState.closeCurrentPanel()
	)
func _physics_process(_delta):
	levelShow.text = "%s/10" % diffEdit.value
	GameRule.difficulty = diffEdit.value
