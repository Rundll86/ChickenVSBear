@tool
extends FullscreenPanelBase

var selectedCount: int = 0
var refreshNeedBaseballCount = 100

@onready var avaliableFeeds: Node2D = $"%avaliableFeeds"
@onready var feedCards: HBoxContainer = $"%feedcards"
@onready var waveLabel: RichTextLabel = $"%wave"
@onready var countLabel: RichTextLabel = $"%count"
@onready var skipBtn: Button = $"%skipBtn"
@onready var refreshBtn: Button = $"%refreshBtn"
@onready var needBB: ItemShow = $"%needBB"

func _ready():
	skipBtn.pressed.connect(
		func():
			finish()
	)
	refreshBtn.pressed.connect(
		func():
			if UIState.player.inventory[ItemStore.ItemType.BASEBALL] >= refreshNeedBaseballCount:
				UIState.player.inventory[ItemStore.ItemType.BASEBALL] -= refreshNeedBaseballCount
				refreshNeedBaseballCount *= 1 + randf_range(GameRule.refreshCountIncreasePercent.x, GameRule.refreshCountIncreasePercent.y)
				regenerateCards()
	)
	ComponentManager.init()
	for i in len(ComponentManager.feeds):
		var feed = ComponentManager.getFeed(i).instantiate() as Feed
		feed.selected.connect(
			func(applied: bool):
				if applied:
					selectedCount += 1
					updateValue()
					if selectedCount >= UIState.player.fields[FieldStore.Entity.FEED_COUNT_CAN_MADE]:
						finish()
		)
		avaliableFeeds.add_child(feed)

func beforeOpen(_args: Array = []):
	selectedCount = 0
	regenerateCards()

func clearCards():
	for i in feedCards.get_children():
		feedCards.remove_child(i)
		avaliableFeeds.add_child(i)
func updateValue():
	waveLabel.text = str(Wave.current + 1)
	countLabel.text = str(UIState.player.fields[FieldStore.Entity.FEED_COUNT_CAN_MADE] - selectedCount)
	needBB.count = refreshNeedBaseballCount
func finish():
	WorldManager.rootNode.spawnWave()
	UIState.closeCurrentPanel()
func regenerateCards():
	updateValue()
	clearCards()
	var feeds = generateCardByQuality()
	for feed in feeds:
		feed.show()
		feed.rebuildInfo()
		avaliableFeeds.remove_child(feed)
		feedCards.add_child(feed)
func generateCardByQuality():
	var feeds = []
	for i in range(len(avaliableFeeds.get_children())):
		var feed = avaliableFeeds.get_children()[i] as Feed
		for j in range(feed.nameLabel.weight(UIState.player)):
			feeds.append(i)
	var result = []
	for i in range(UIState.player.fields[FieldStore.Entity.FEED_COUNT_SHOW]):
		feeds.shuffle()
		var feed = avaliableFeeds.get_children()[feeds[0]] as Feed
		feed.rebuildInfo()
		result.append(feed)
		feeds = ArrayTool.removeAll(feeds, feeds[0])
	return result
