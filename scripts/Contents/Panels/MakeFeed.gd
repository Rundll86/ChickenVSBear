@tool
extends FullscreenPanelBase

@onready var avaliableFeeds: Node = $"%avaliableFeeds"
@onready var feedCards: HBoxContainer = $"%feedcards"

func beforeOpen():
	var feeds: Array[Feed] = []
	for i in avaliableFeeds.get_children():
		feeds.append(i)
	var allHad = false
	while not allHad:
		afterClose()
		feeds.shuffle()
		for i in range(3):
			var feed = feeds[i] as Feed
			feed.show()
			avaliableFeeds.remove_child(feed)
			feedCards.add_child(feed)
			if feed.allHad(UIState.player):
				allHad = true
func afterClose():
	for i in feedCards.get_children():
		i.hide()
		feedCards.remove_child(i)
		avaliableFeeds.add_child(i)
