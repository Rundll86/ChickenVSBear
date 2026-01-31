@tool
extends FullscreenPanelBase

@onready var initialFeedSelection: HBoxContainer = $%initialFeedSelection
@onready var initialWeaponSelection: HBoxContainer = $%initialWeaponSelection
@onready var startBtn: Button = $%startBtn
@onready var title1: Label = $%title1
@onready var title2: Label = $%title2

func _ready():
	startBtn.pressed.connect(func(): UIState.closeCurrentPanel())

func beforeOpen(_args: Array = []):
	clearFeeds()
	clearWeapons()
	ComponentManager.feeds.shuffle()
	for feed in ComponentManager.feeds:
		var card = feed.instantiate() as Feed
		card.freeToBuy = true
		if card.topic == FeedName.Topic.WEAPON:
			initialWeaponSelection.add_child(card)
			card.selected.connect(
				func(_x):
					clearWeapons()
					title2.hide()
			)
		else:
			initialFeedSelection.add_child(card)
			card.selected.connect(
				func(_x):
					clearFeeds()
					title1.hide()
			)

func clearFeeds():
	for feed in initialFeedSelection.get_children():
		feed.queue_free()
func clearWeapons():
	for weapon in initialWeaponSelection.get_children():
		weapon.queue_free()
