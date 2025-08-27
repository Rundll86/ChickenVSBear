@tool
extends FullscreenPanelBase

@onready var avaliableFeeds: Node = $"%avaliableFeeds"
@onready var feedCards: HBoxContainer = $"%feedcards"

func _ready():
	for i in avaliableFeeds.get_children():
		i.hide()

func beforeOpen():
	var feeds: Array[Feed] = []
	for i in avaliableFeeds.get_children():
		feeds.append(i)
	var allHad = false
	while not allHad:
		afterClose()
		feeds.shuffle()
		for i in range(3):
			var feed = feeds[i]
			var cloned = feed.duplicate() as Feed
			cloned.show()
			feedCards.add_child(cloned)
			if cloned.allHad(UIState.player):
				allHad = true
func afterClose():
	for i in feedCards.get_children():
		feedCards.remove_child(i)
