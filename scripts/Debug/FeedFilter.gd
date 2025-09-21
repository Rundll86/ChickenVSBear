@tool
extends HBoxContainer

enum ComposeMode {
	ALL,
	ANY,
}

@export var targetFields: Array[FieldStore.Entity] = []
@export var targetTopics: Array[FeedName.Topic] = []
@export var composeMode: ComposeMode = ComposeMode.ALL
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
		var feed = load(file).instantiate() as Feed
		
		# 检查字段条件
		var fieldPassed: bool = true
		if !targetFields.is_empty():
			fieldPassed = checkFieldCondition(feed)
		
		# 检查主题条件
		var topicPassed: bool = true
		if !targetTopics.is_empty():
			topicPassed = checkTopicCondition(feed)
		
		# 如果两个条件都满足，则添加到容器中
		if fieldPassed and topicPassed:
			add_child(feed)

func checkFieldCondition(feed: Feed) -> bool:
	var passed: bool = true
	for targetField in targetFields:
		var haveThis = false
		for feedField in feed.fields:
			if feedField == targetField:
				haveThis = true
				break
		passed = haveThis
		if composeMode == ComposeMode.ALL:
			if not passed:
				break
		elif composeMode == ComposeMode.ANY:
			if passed:
				break
	return passed

func checkTopicCondition(feed: Feed) -> bool:
	var passed: bool = false
	for targetTopic in targetTopics:
		var haveThis = feed.topic == targetTopic
		passed = haveThis
		if passed:
			break
	return passed