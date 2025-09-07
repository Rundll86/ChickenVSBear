@tool
extends FullscreenPanelBase

@onready var audio = $"%audio"
@onready var deadreason = $"%deadreason"

func beforeOpen(args: Array = []):
	audio.play()
	var reasonTemplate = MathTool.randc_from(GameRule.deadReasons)
	deadreason.text = (reasonTemplate + "凶手是%s。") % args
