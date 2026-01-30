@tool
extends FullscreenPanelBase

@onready var initialFeedSelection: HBoxContainer = $%initialFeedSelection

func beforeOpen(_args: Array = []):
	for feed in initialFeedSelection.get_children():
		feed.queue_free()
	ComponentManager.feeds.shuffle()
	for feed in ComponentManager.feeds:
		var card = feed.instantiate() as Feed
		if card.topic == FeedName.Topic.WEAPON:
			continue
		card.freeToBuy = true
		card.selected.connect(func(_success): UIState.closeCurrentPanel())
		initialFeedSelection.add_child(card)
