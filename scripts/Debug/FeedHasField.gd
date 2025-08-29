@tool
extends HBoxContainer

enum ComposeMode {
	ALL,
	ANY,
}

@export var targetFields: Array[FieldStore.Entity] = []
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
		var passed: bool = true
		var feed = load(file).instantiate() as Feed
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
		if passed:
			add_child(feed)
