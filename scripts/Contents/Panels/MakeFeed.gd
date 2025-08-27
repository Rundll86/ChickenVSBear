@tool
extends FullscreenPanelBase

var selectedCount: int = 0

@onready var avaliableFeeds: Node2D = $"%avaliableFeeds"
@onready var feedCards: HBoxContainer = $"%feedcards"
@onready var waveLabel: RichTextLabel = $"%wave"
@onready var countLabel: RichTextLabel = $"%count"
@onready var skipBtn: Button = $"%skipBtn"

func _ready():
	skipBtn.pressed.connect(
		func():
			finish()
	)
	for file in DirTool.listdir("res://components/Feeds/"):
		var i = load(file).instantiate() as Feed
		i.selected.connect(
			func(applied: bool):
				if applied:
					selectedCount += 1
					updateValue()
					if selectedCount >= UIState.player.fields[FieldStore.Entity.FEED_COUNT_CAN_MADE]:
						finish()
		)
		avaliableFeeds.add_child(i)

func beforeOpen():
	selectedCount = 0
	afterClose()
	updateValue()
	var feeds: Array[Feed] = []
	for i in avaliableFeeds.get_children():
		feeds.append(i)
	feeds.shuffle()
	for i in range(UIState.player.fields[FieldStore.Entity.FEED_COUNT_SHOW]):
		var feed = feeds[i] as Feed
		avaliableFeeds.remove_child(feed)
		feedCards.add_child(feed)
func afterClose():
	for i in feedCards.get_children():
		feedCards.remove_child(i)
		avaliableFeeds.add_child(i)

func updateValue():
	waveLabel.text = str(Wave.current + 1)
	countLabel.text = str(UIState.player.fields[FieldStore.Entity.FEED_COUNT_CAN_MADE] - selectedCount)
func finish():
	Wave.next()
	UIState.closeCurrentPanel()
