@tool
extends PanelContainer
class_name Weapon

@export var avatarTexture: Texture2D = null
@export var displayName: String = "未命名武器"
@export var quality: WeaponName.Quality = WeaponName.Quality.COMMON
@export var typeTopic: WeaponName.TypeTopic = WeaponName.TypeTopic.IMPACT
@export var soulLevel: int = 1
@export var costBeachball: int = 500
@export var store: Dictionary = {
	"atk": 10
}
@export var storeType: Dictionary = {
	"atk": FieldStore.DataType.INTEGER
}
@export var descriptionTemplate: String = "造成$atk点伤害。"
@export var needEnergy: float = 0
@export var cooldown: float = 100
@export var debugRebuild: bool = false
@export var level: int = 0

@onready var avatarRect: TextureRect = $"%avatar"
@onready var nameLabel: WeaponName = $"%name"
@onready var energyLabel: Label = $"%energy"
@onready var beachball: ItemShow = $"%beachball"
@onready var soul: ItemShow = $"%soul"
@onready var descriptionLabel: RichTextLabel = $"%description"
@onready var updateBtn: Button = $"%updateBtn"
@onready var extractBtn: Button = $"%extractBtn"
@onready var inlayBtn: Button = $"%inlayBtn"
@onready var sounds: Node2D = $"%sounds"
@onready var moveLeftBtn: Button = $"%moveleft"
@onready var moveRightBtn: Button = $"%moveright"

var cooldownTimer: CooldownTimer = null
var originalStore: Dictionary = {}

func _ready():
	cooldownTimer = CooldownTimer.new()
	cooldownTimer.cooldown = cooldown
	originalStore = store
	updateBtn.mouse_entered.connect(func(): rebuildInfo(true))
	updateBtn.mouse_exited.connect(func(): rebuildInfo())
	extractBtn.mouse_entered.connect(func(): rebuildInfo(true))
	extractBtn.mouse_exited.connect(func(): rebuildInfo())
	inlayBtn.mouse_entered.connect(func(): rebuildInfo(true))
	inlayBtn.mouse_exited.connect(func(): rebuildInfo())
	updateBtn.pressed.connect(
		func():
			apply(UIState.player)
	)
	extractBtn.pressed.connect(
		func():
			if soulLevel > WeaponName.SoulLevel.NORMALIZE:
				UIState.player.getItem({
					ItemStore.ItemType.SOUL: soulLevel - 1
				})
				soulLevel -= 1
				updateStore(level, UIState.player)
				rebuildInfo()
	)
	inlayBtn.pressed.connect(
		func():
			if soulLevel < WeaponName.SoulLevel.INFINITY:
				if UIState.player.useItem({
					ItemStore.ItemType.SOUL: soulLevel
				}):
					soulLevel += 1
					updateStore(level, UIState.player)
					rebuildInfo()
	)
	moveLeftBtn.pressed.connect(
		func():
			if get_parent():
				var myIndex = get_index()
				var leftIndex = max(myIndex - 1, 0)
				get_parent().move_child(self, leftIndex)
				ArrayTool.swap(UIState.player.weapons, myIndex, leftIndex)
				UIState.player.rebuildWeaponIcons()
	)
	moveRightBtn.pressed.connect(
		func():
			if get_parent():
				var myIndex = get_index()
				var rightIndex = min(myIndex + 1, get_parent().get_child_count() - 1)
				get_parent().move_child(self, rightIndex)
				ArrayTool.swap(UIState.player.weapons, myIndex, rightIndex)
				UIState.player.rebuildWeaponIcons()
	)
	for i in sounds.get_children():
		i.process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	rebuildInfo()
	debugRebuild = false # 只能在编辑器里打开
func _physics_process(_delta):
	if debugRebuild:
		rebuildInfo()

func canUpdate():
	return UIState.player.hasItem({ItemStore.ItemType.BEACHBALL: costBeachball})
func canInlay():
	return UIState.player.hasItem({ItemStore.ItemType.SOUL: soulLevel})
func apply(entity: EntityBase) -> bool:
	if canUpdate():
		level += 1
		entity.inventory[ItemStore.ItemType.BEACHBALL] -= costBeachball
		updateStore(level, entity)
		costBeachball = floor(GameRule.weaponUpdateCost * costBeachball)
		rebuildInfo(true)
		return true
	return false
func updateStore(to: int, entity: EntityBase):
	store = update(to, originalStore.duplicate(), entity)
func multipiler() -> float:
	if is_instance_valid(UIState.player):
		return 1 - UIState.player.fields.get(FieldStore.Entity.PRICE_REDUCTION)
	else:
		return 1
func rebuildInfo(showNext: bool = false):
	avatarRect.texture = avatarTexture
	nameLabel.displayName = displayName
	nameLabel.quality = quality
	nameLabel.typeTopic = typeTopic
	nameLabel.soulLevel = soulLevel
	nameLabel.level = level
	energyLabel.text = "%.1f" % needEnergy
	beachball.count = costBeachball
	soul.count = soulLevel
	if is_instance_valid(UIState.player):
		beachball.enough = canUpdate()
		soul.enough = canInlay()
	descriptionLabel.text = buildDescription(showNext && (canUpdate() || canInlay()))
func formatValue(value: Variant, type: FieldStore.DataType) -> String:
	if type == FieldStore.DataType.VALUE:
		return "%.2f" % value
	elif type == FieldStore.DataType.INTEGER:
		return "%d" % value
	elif type == FieldStore.DataType.PERCENT:
		return ("%d" % (value * 100)) + "%"
	elif type == FieldStore.DataType.ANGLE:
		return "%.1f°" % value
	elif type == FieldStore.DataType.FREQUENCY:
		return "%.1fHz" % value
	else:
		return str(value)
func buildDescription(showNext: bool = false) -> String:
	var current = store
	var next = update(level + 1, originalStore.duplicate(), UIState.player)
	var result = descriptionTemplate
	for key in store.keys():
		var data = current[key]
		var nextData = next[key]
		var type = storeType.get(key, FieldStore.DataType.VALUE)
		data = formatValue(data, type)
		nextData = formatValue(nextData, type)
		var text
		if showNext:
			text = "[color=cyan]%s[/color]→[color=yellow]%s[/color]" % [data, nextData]
		else:
			text = "[color=cyan]%s[/color]" % data
		result = result.replace("$" + key, text)
	return "[center]%s[/center]" % result
func readStore(key: String, default: Variant = null):
	return store.get(key, default)
func playSound(sound: String):
	var body = sounds.get_node_or_null(sound)
	if body is AudioStreamPlayer2D:
		var cloned = body.duplicate() as AudioStreamPlayer2D
		add_child(cloned)
		cloned.play()
		await cloned.finished
		cloned.queue_free()
func tryAttack(entity: EntityBase):
	cooldownTimer.speedScale = entity.fields.get(FieldStore.Entity.ATTACK_SPEED)
	if cooldownTimer.start():
		if entity.useEnergy(needEnergy):
			return await attack(entity)

# 抽象
func update(_to: int, origin: Dictionary, _entity: EntityBase):
	return origin
func attack(_entity: EntityBase):
	pass
