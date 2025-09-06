@tool
extends HBoxContainer

@export var targetTopics: Array[FeedName.Topic] = []
@export var clickToRefresh: bool = false

var lastState: bool = false

func _ready():
	rebuild()
func _physics_process(_delta):
	if clickToRefresh != lastState:
		lastState = clickToRefresh
		rebuild()

func rebuild():
	for i in get_children():
		i.queue_free()
	var files = DirTool.listdir("res://components/Feeds/")
	for file in files:
		var passed: bool = false
		var feed = load(file).instantiate() as Feed
		for targetTopic in targetTopics:
			var haveThis = feed.topic == targetTopic
			passed = haveThis
			if passed:
				break
		if passed:
			add_child(feed)
