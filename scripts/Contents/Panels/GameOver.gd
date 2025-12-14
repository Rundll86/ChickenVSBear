@tool
extends FullscreenPanelBase

@onready var audio: AudioStreamPlayer2D = $"%audio"
@onready var deadreason: RichTextLabel = $"%deadreason"

func beforeOpen(args: Array = []):
	audio.play()
	var reasonTemplate = MathTool.randomChoiceFrom(GameRule.deadReasons)
	deadreason.text = ("[color=gray]" + reasonTemplate + "凶手是[b]%s[/b]的[b]%s[/b]。[/color]") % args
