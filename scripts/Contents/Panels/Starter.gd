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
	levelShow.text = "%d ∈ [%d, %d]" % [diffEdit.value, diffEdit.min_value, diffEdit.max_value]
	GameRule.difficulty = diffEdit.value
