extends FullscreenPanelBase

@onready var avaliableFeeds: Node = $"%avaliableFeeds"
@onready var feedCards: HBoxContainer = $"%feedcards"

func hideAll():
	for i in avaliableFeeds.get_children():
		i.hide()

func beforeOpen():
	hideAll()
	var feeds = []
	for i in avaliableFeeds.get_children():
		feeds.append(i)
	feeds.shuffle()
	for i in range(3):
		var feed = feeds[i]
		var cloned = feed.duplicate()
		cloned.show()
		feedCards.add_child(cloned)
func afterClose():
	for i in feedCards.get_children():
		feedCards.remove_child(i)
