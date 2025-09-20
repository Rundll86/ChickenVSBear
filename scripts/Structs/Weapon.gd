@tool
extends PanelContainer
class_name Weapon

@export var avatarTexture: Texture2D = preload("res://icon.svg")
@export var displayName: String = "未命名饲料"
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
@onready var beachballLabel: Label = $"%beachball"
@onready var soulLabel: Label = $"%soul"
@onready var descriptionLabel: RichTextLabel = $"%description"
@onready var updateBtn: Button = $"%updateBtn"
@onready var extractBtn: Button = $"%extractBtn"
@onready var inlayBtn: Button = $"%inlayBtn"
@onready var sounds: Node2D = $"%sounds"

var cooldownTimer: CooldownTimer = null
var originalStore: Dictionary = {}

func _ready():
	cooldownTimer = CooldownTimer.new()
	cooldownTimer.cooldown = cooldown
	originalStore = store
	updateBtn.pressed.connect(
		func():
			apply(UIState.player)
	)
	extractBtn.pressed.connect(
		func():
			if soulLevel > WeaponName.SoulLevel.NORMALIZE:
				UIState.player.getItem({
					ItemStore.ItemType.SOUL: soulLevel
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
	for i in sounds.get_children():
		i.process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	rebuildInfo()
	debugRebuild = false # 只能在编辑器里打开
func _physics_process(_delta):
	if debugRebuild:
		rebuildInfo()

func allHad(entity: EntityBase) -> bool:
	return entity.inventory[ItemStore.ItemType.BEACHBALL] >= costBeachball
func apply(entity: EntityBase):
	var allHave = allHad(entity)
	if allHave:
		level += 1
		entity.inventory[ItemStore.ItemType.BEACHBALL] -= costBeachball
		updateStore(level, entity)
		costBeachball = floor(GameRule.weaponUpdateCost * costBeachball)
		rebuildInfo()
	return allHave
func updateStore(to: int, entity: EntityBase):
	store = update(to, originalStore.duplicate(), entity)
func multipiler() -> float:
	if is_instance_valid(UIState.player):
		return 1 - UIState.player.fields.get(FieldStore.Entity.PRICE_REDUCTION)
	else:
		return 1
func rebuildInfo():
	avatarRect.texture = avatarTexture
	nameLabel.displayName = displayName
	nameLabel.quality = quality
	nameLabel.typeTopic = typeTopic
	nameLabel.soulLevel = soulLevel
	nameLabel.level = level
	energyLabel.text = "%.1f" % needEnergy
	beachballLabel.text = str(costBeachball)
	soulLabel.text = str(soulLevel)
	descriptionLabel.text = buildDescription()
func formatValue(value: Variant, type: FieldStore.DataType) -> String:
	if type == FieldStore.DataType.VALUE:
		return "%.2f" % value
	elif type == FieldStore.DataType.INTEGER:
		return "%d" % value
	elif type == FieldStore.DataType.PERCENT:
		return ("%d" % (value * 100)) + "%"
	elif type == FieldStore.DataType.ANGLE:
		return "%.1f°" % value
	else:
		return str(value)
func buildDescription() -> String:
	var current = store
	var next = update(level + 1, originalStore.duplicate(), UIState.player)
	var result = descriptionTemplate
	for key in store.keys():
		var data = current[key]
		var nextData = next[key]
		var type = storeType.get(key, FieldStore.DataType.VALUE)
		data = formatValue(data, type)
		nextData = formatValue(nextData, type)
		result = result.replace("$" + key, "[color=cyan]%s[/color]→[color=yellow]%s[/color]" % [data, nextData])
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
	if cooldownTimer.start():
		if entity.useEnergy(needEnergy):
			return await attack(entity)

# 抽象
func update(_to: int, origin: Dictionary, _entity: EntityBase):
	return origin
func attack(_entity: EntityBase):
	pass
