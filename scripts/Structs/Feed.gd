@tool
extends PanelContainer
class_name Feed

signal selected(applied: bool)

@export var avatarTexture: Texture2D = null
@export var displayName: String = "未命名饲料"
@export var quality: FeedName.Quality = FeedName.Quality.COMMON
@export var topic: FeedName.Topic = FeedName.Topic.SURVIVAL
@export var fields: Array[FieldStore.Entity] = []
@export var fieldValues: Array[float] = []
@export var weapons: Array[PackedScene] = []
@export var costs: Array[ItemStore.ItemType] = []
@export var costCounts: Array[int] = []

@onready var avatarRect: TextureRect = $"%avatar"
@onready var nameLabel: FeedName = $"%name"
@onready var fieldsBox: VBoxContainer = $"%fields"
@onready var weaponsBox: VBoxContainer = $"%weapons"
@onready var costsBox: GridContainer = $"%costs"
@onready var selectButton: Button = $"%selectBtn"

func _ready():
	selectButton.pressed.connect(
		func():
			apply(UIState.player)
	)
	rebuildInfo()

func allHad(entity: EntityBase) -> bool:
	for i in range(min(costs.size(), costCounts.size())):
		var item = costs[i]
		var count = countOf(i)
		if entity.inventory[item] < count:
			return false
	return true
func apply(entity: EntityBase):
	var allHave = allHad(entity)
	if allHave:
		for i in range(min(costs.size(), costCounts.size())):
			var item = costs[i]
			var count = countOf(i)
			entity.inventory[item] -= count
		for i in range(min(fields.size(), fieldValues.size())):
			var field = fields[i]
			var value = fieldValues[i]
			var applier = FieldStore.entityApplier.get(field)
			if !applier or applier.call(entity, value):
				entity.fields[field] += value
				entity.fields[field] = clamp(entity.fields[field], FieldStore.entityMinValueMap.get(field, 0), FieldStore.entityMaxValueMap.get(field, INF))
		for i in weapons:
			var instance = i.instantiate() as Weapon
			if UIState.player.weaponBag.has(instance.displayName):
				UIState.player.getItem({
					ItemStore.ItemType.SOUL: instance.soulLevel
				})
			else:
				instance.hide()
				entity.weapons.append(instance)
				entity.weaponBag.append(instance.displayName)
				entity.weaponStore.add_child(instance)
				entity.rebuildWeaponIcons()
		hide()
	selected.emit(allHave)
	return allHave
func countOf(index: int) -> int:
	return ceil(costCounts[index] * multipiler())
func multipiler() -> float:
	if is_instance_valid(UIState.player):
		return 1 - UIState.player.fields.get(FieldStore.Entity.PRICE_REDUCTION)
	else:
		return 1
func rebuildInfo():
	avatarRect.texture = avatarTexture
	nameLabel.displayName = displayName
	nameLabel.quality = quality
	nameLabel.topic = topic
	for i in fieldsBox.get_children():
		i.queue_free()
	var noField = true
	for i in range(min(fields.size(), fieldValues.size())):
		noField = false
		var field = fields[i]
		var value = fieldValues[i]
		var fieldShow: FieldShow = ComponentManager.getUIComponent("FieldShow").instantiate()
		fieldShow.field = field
		fieldShow.value = value
		fieldShow.showAdvantage = true
		if is_instance_valid(UIState.player):
			fieldShow.maxed = value + UIState.player.fields[field] > FieldStore.entityMaxValueMap.get(field, INF)
		fieldsBox.add_child(fieldShow)
	if noField:
		fieldsBox.add_child(QuickUI.smallText("无词条"))
	for i in weaponsBox.get_children():
		i.queue_free()
	for weapon in weapons:
		var weaponShow: WeaponShow = ComponentManager.getUIComponent("WeaponShow").instantiate()
		weaponShow.weapon = weapon
		if is_instance_valid(UIState.player):
			weaponShow.operation = WeaponShow.Operation.EXTRACT if UIState.player.weaponBag.has(weapon.instantiate().displayName) else WeaponShow.Operation.GET
		weaponShow.visible = true
		weaponsBox.add_child(weaponShow)
	for i in costsBox.get_children():
		i.queue_free()
	for i in range(min(costs.size(), costCounts.size())):
		var cost = costs[i]
		var count = countOf(i)
		var costShow: ItemShow = ComponentManager.getUIComponent("ItemShow").instantiate()
		costShow.enough = is_instance_valid(UIState.player) and UIState.player.inventory[cost] >= count
		costShow.type = cost
		costShow.count = count
		costsBox.add_child(costShow)
