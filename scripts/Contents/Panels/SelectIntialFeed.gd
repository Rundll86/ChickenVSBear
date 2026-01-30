@tool
extends FullscreenPanelBase

@onready var initialFeedSelection: HBoxContainer = $%initialFeedSelection

func beforeOpen(_args: Array = []):
	for feed in initialFeedSelection.get_children():
		feed.queue_free()
	for feed in ComponentManager.feeds:
		var card = feed.instantiate() as Feed
		initialFeedSelection.add_child(card)
