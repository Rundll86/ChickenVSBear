extends CharacterBody2D
class_name EntityBase # 这是个抽象类

signal hit(damage: float, bullet: BulletBase, crit: bool)
signal healed(amount: float)
signal healthChanged(health: float)
signal died()

signal energyChanged(energy: float, dontChangeDirection: bool)

const TITLE_FLAG = INF
var fields = {
	"生存": TITLE_FLAG,
	FieldStore.Entity.MAX_HEALTH: 100,
	FieldStore.Entity.HEAL_ABILITY: 1,
	FieldStore.Entity.EXTRA_APPLE_MAX: 0,
	FieldStore.Entity.DROP_APPLE_RATE: 0,
	FieldStore.Entity.PENARATION_RESISTANCE: 0,
	"储能": TITLE_FLAG,
	FieldStore.Entity.MAX_ENERGY: 200,
	FieldStore.Entity.SAVE_ENERGY: 1,
	FieldStore.Entity.ENERGY_MULTIPILER: 1,
	FieldStore.Entity.ENERGY_REGENERATION: 1,
	FieldStore.Entity.PERFECT_MISS_WINDOW: 0.05,
	"子弹": TITLE_FLAG,
	FieldStore.Entity.OFFSET_SHOOT: 3,
	FieldStore.Entity.PENERATE: 0,
	FieldStore.Entity.EXTRA_BULLET_COUNT: 0,
	FieldStore.Entity.BULLET_SPLIT: 0,
	FieldStore.Entity.BULLET_REFRACTION: 0,
	FieldStore.Entity.BULLET_TRACE: 0,
	"速度": TITLE_FLAG,
	FieldStore.Entity.ATTACK_SPEED: 1,
	FieldStore.Entity.MOVEMENT_SPEED: 1,
	"伤害": TITLE_FLAG,
	FieldStore.Entity.DAMAGE_MULTIPILER: 1,
	FieldStore.Entity.CRIT_RATE: 0.05,
	FieldStore.Entity.CRIT_DAMAGE: 1,
	"概率": TITLE_FLAG,
	FieldStore.Entity.LUCK_VALUE: 1,
	"饲料": TITLE_FLAG,
	FieldStore.Entity.PRICE_REDUCTION: 0,
	FieldStore.Entity.FEED_COUNT_SHOW: 3,
	FieldStore.Entity.FEED_COUNT_CAN_MADE: 1,
	"掉落物": TITLE_FLAG,
	FieldStore.Entity.DROPPED_ITEM_COLLECT_RADIUS: 60,
	FieldStore.Entity.GRAVITY: 10,
}
var attackCooldownMap = {
	0: 100
}
var attackCooldowner = {
	0: CooldownTimer.new()
}
var inventory = {
	ItemStore.ItemType.BASEBALL: 200,
	ItemStore.ItemType.BASKETBALL: 200,
	ItemStore.ItemType.APPLE: 5,
	ItemStore.ItemType.BEACHBALL: 0,
	ItemStore.ItemType.SOUL: 0,
}
var inventoryMax = {
	ItemStore.ItemType.BASEBALL: INF, # 无限
	ItemStore.ItemType.BASKETBALL: INF,
	ItemStore.ItemType.APPLE: 5,
	ItemStore.ItemType.BEACHBALL: INF,
	ItemStore.ItemType.SOUL: INF,
}

@export var defaultCooldownUnit: float = 100
@export var isBoss: bool = false
@export var displayName: String = "未知实体"
@export var sprintMultiplier: float = 5
@export var drops: Array[ItemStore.ItemType] = []
@export var dropCounts: Array[Vector2] = []
@export var appleCount: Vector2i = Vector2(0, 2) # 死亡后掉落的苹果数量
@export var level: int = 1
@export var currentInvinsible: bool = false

@onready var animatree: AnimationTree = $"%animatree"
@onready var texture: AnimatedSprite2D = $"%texture"
@onready var hurtbox: Area2D = $"%hurtbox"
@onready var sounds: Node2D = $"%sounds"
@onready var hurtAnimator: AnimationPlayer = $"%hurtAnimator"
@onready var stageAnimator: AnimationPlayer = $"%stageAnimator"
@onready var damageAnchor: Node2D = $"%damageAnchor"
@onready var trailParticle: GPUParticles2D = $"%trailParticle"
@onready var weaponStore: Node2D = $"%weaponStore"
var statebar: EntityStateBar

var health: float = 0
var energy: float = 0
var sprinting: bool = false
var targetableSprinting: bool = false
var trailing: bool = false

var lastDirection: int = 1
var currentFocusedBoss: EntityBase = null
var charginup: bool = false
var weapons: Array[Weapon] = []
var weaponBag: Array[String] = []
var canRunAi: bool = true
var currentStage: int = 0
var spawnTime: float = 0

func _ready():
	spawnTime = WorldManager.getTime()
	register()
	var selfStatebar: EntityStateBar = $"%statebar"
	if isBoss:
		selfStatebar.hide()
	else:
		statebar = selfStatebar
		statebar.entity = self
	if isPlayer():
		for i in weaponStore.get_children():
			i.hide()
			weapons.append(i)
			weaponBag.append(i.displayName)
		statebar.levelLabels.hide()
		UIState.player = self
		energyChanged.connect(
			func(newEnergy, dontChangeDirection):
				UIState.energyPercent.maxValue = fields.get(FieldStore.Entity.MAX_ENERGY)
				if dontChangeDirection:
					UIState.energyPercent.currentValue = newEnergy
				else:
					UIState.energyPercent.setCurrent(newEnergy)
		)
		rebuildWeaponIcons()
	else:
		if !currentFocusedBoss:
			currentFocusedBoss = get_tree().get_nodes_in_group("players")[0]
		applyLevel()
	health = fields.get(FieldStore.Entity.MAX_HEALTH)
	energy = fields.get(FieldStore.Entity.MAX_ENERGY)
	if is_instance_valid(statebar):
		statebar.forceSync()
	healthChanged.connect(
		func(newHealth):
			if is_instance_valid(statebar):
				statebar.healthBar.maxValue = fields.get(FieldStore.Entity.MAX_HEALTH)
				statebar.healthBar.setCurrent(newHealth)
	)
	healthChanged.emit(health)
	energyChanged.emit(energy, false)
	spawn()
func _process(_delta):
	health = clamp(health, 0, fields.get(FieldStore.Entity.MAX_HEALTH))
	energy = clamp(energy, 0, fields.get(FieldStore.Entity.MAX_ENERGY))
	for i in inventory:
		inventory[i] = clamp(inventory[i], 0, inventoryMax[i])
	if isBoss:
		if UIState.player.currentFocusedBoss == self:
			statebar = UIState.bossbar
		else:
			statebar = null
	if is_instance_valid(statebar):
		statebar.levelLabel.text = str(level)
func _physics_process(_delta: float) -> void:
	animatree.set("parameters/blend_position", lerpf(animatree.get("parameters/blend_position"), lastDirection, 0.2))
	if sprinting:
		if sprintAi():
			sprinting = false
	else:
		velocity = Vector2.ZERO
		if (isPlayer() or is_instance_valid(currentFocusedBoss)) and not charginup and canRunAi:
			ai()
	move_and_slide()
	storeEnergy(randf_range(0.01, 0.05 + fields.get(FieldStore.Entity.ENERGY_REGENERATION) - 1), true)
	trailParticle.emitting = trailing

# 通用方法
func rebuildWeaponIcons():
	if isPlayer():
		for i in UIState.skillIconContainer.get_children():
			i.queue_free()
		for i in weapons:
			var icon: SkillIcon = ComponentManager.getUIComponent("SkillIcon").instantiate()
			icon.weapon = i
			UIState.skillIconContainer.add_child(icon)
func timeLived():
	return WorldManager.getTime() - spawnTime
func setStage(stage: int):
	if currentStage == stage:
		return
	currentInvinsible = true
	canRunAi = false
	var oldStage = currentStage
	currentStage = stage
	stageAnimator.play("exit")
	await stageAnimator.animation_finished
	await exitStage(oldStage)
	await enterStage(stage)
	stageAnimator.play("enter")
	await stageAnimator.animation_finished
	canRunAi = true
	currentInvinsible = false
func applyLevel():
	fields[FieldStore.Entity.MAX_HEALTH] *= (1 + GameRule.entityHealthIncreasePerWave * (GameRule.difficulty + 1)) ** level
	fields[FieldStore.Entity.DAMAGE_MULTIPILER] *= (1 + GameRule.entityDamageIncreasePerWave * (GameRule.difficulty + 1)) ** level
func displace(direction: Vector2, isSprinting: bool = false):
	return (direction if isSprinting else direction.normalized()) * fields.get(FieldStore.Entity.MOVEMENT_SPEED) * 400 * abs(animatree.get("parameters/blend_position"))
func move(direction: Vector2, isSprinting: bool = false):
	velocity = displace(direction, isSprinting)
	var currentDirection = sign(direction.x)
	if currentDirection != 0:
		lastDirection = currentDirection
func getSprintInitialDisplace():
	return displace(velocity) * sprintMultiplier
func getSprintProgress():
	return velocity.length() / getSprintInitialDisplace().length()
func takeDamage(bullet: BulletBase, crit: bool):
	hurtAnimator.play("hurt")
	var baseDamage: float = bullet.damage * bullet.launcher.fields.get(FieldStore.Entity.DAMAGE_MULTIPILER) * randf_range(1 - GameRule.damageOffset, 1 + GameRule.damageOffset)
	var damage = baseDamage + baseDamage * int(crit) * fields.get(FieldStore.Entity.CRIT_DAMAGE)
	var perfectMiss = false
	if sprinting:
		playSound("miss")
		if getSprintProgress() > 1 - fields.get(FieldStore.Entity.PERFECT_MISS_WINDOW):
			perfectMiss = true
		if perfectMiss:
			storeEnergy(damage * 2)
		else:
			storeEnergy(damage * 0.35)
		damage = 0
	else:
		playSound("hurt")
		storeEnergy(damage * -0.5)
	position += Vector2.from_angle(bullet.position.angle_to_point(position)) * bullet.knockback
	hit.emit(damage, bullet, crit)
	healthChanged.emit(health)
	health -= damage
	DamageLabel.create(damage, crit || perfectMiss, damageAnchor.global_position + MathTool.randv2_range(GameRule.damageLabelSpawnOffset))
	if isBoss and bullet.launcher.isPlayer():
		bullet.launcher.setBoss(self)
	if health <= 0:
		if isBoss:
			bullet.launcher.storeEnergy(energy * 0.35)
			bullet.launcher.setBoss(null)
		tryDie(bullet)
	return damage
func collectItem(itemType: ItemStore.ItemType, amount: int):
	inventory[itemType] += amount
	playSound("collect")
func storeEnergy(value: float, dontChangeDirection: bool = false):
	energy += value * fields.get(FieldStore.Entity.ENERGY_MULTIPILER)
	energyChanged.emit(energy, dontChangeDirection)
func useEnergy(value: float):
	value /= fields.get(FieldStore.Entity.SAVE_ENERGY)
	var state = energy >= value
	if state:
		energy -= value
		energyChanged.emit(energy, false)
	return state
func tryAttack(type: int, needChargeUp: bool = false):
	var weapon: Weapon
	if isPlayer():
		if len(weapons) > type:
			weapon = weapons[type]
		else:
			return
	var state
	if isPlayer():
		state = true
	else:
		var cooldownTimer: CooldownTimer
		if !attackCooldowner.has(type):
			attackCooldowner[type] = CooldownTimer.new()
		cooldownTimer = attackCooldowner[type]
		cooldownTimer.cooldown = attackCooldownMap.get(type, defaultCooldownUnit)
		state = cooldownTimer.start()
	if state:
		if needChargeUp:
			charginup = true
			await EffectController.create(ComponentManager.getEffect("AttackStar"), damageAnchor.global_position).shot()
			charginup = false
		if isPlayer():
			if await weapon.tryAttack(self):
				weapon.playSound("attack")
		else:
			if await attack(type):
				playSound("attack" + str(type))
	return state
func trySprint():
	trailing = true
	playSound("sprint")
	sprinting = true
	sprint()
	await TickTool.until(func(): return !sprinting)
	trailing = false
func sprintTo(target: Vector2, speed: float):
	await TickTool.until(func(): return !targetableSprinting)
	targetableSprinting = true
	trailing = true
	await TickTool.until(
		func():
			position += (target - position) * speed
			return position.distance_to(target) < 10
	)
	position = target
	trailing = false
	targetableSprinting = false
func tryDie(by: BulletBase = null):
	if is_queued_for_deletion(): return
	if is_instance_valid(by):
		for drop in range(min(len(drops), len(dropCounts))):
			var item = drops[drop]
			var count = ceil(randf_range(dropCounts[drop].x, dropCounts[drop].y))
			for i in range(count):
				ItemDropped.generate(item, randi_range(1, int(sqrt(count) + GameRule.difficulty)), position + MathTool.randv2_range(GameRule.itemDroppedSpawnOffset))
		if MathTool.rate(
			GameRule.appleDropRate +
			by.launcher.fields.get(FieldStore.Entity.DROP_APPLE_RATE) +
			GameRule.appleDropRateInfluenceByLuckValue * by.launcher.fields[FieldStore.Entity.LUCK_VALUE]
		) or isBoss:
			for i in randi_range(appleCount.x, appleCount.y):
				ItemDropped.generate(ItemStore.ItemType.APPLE, 1, position + MathTool.randv2_range(GameRule.itemDroppedSpawnOffset))
		ItemDropped.generate(
			ItemStore.ItemType.BEACHBALL,
			fields[FieldStore.Entity.MAX_HEALTH] * randf_range(1 - GameRule.beachballOffset, 1 + GameRule.beachballOffset),
			position + MathTool.randv2_range(GameRule.itemDroppedSpawnOffset)
		)
		if isPlayer():
			if UIState.player == self:
				UIState.setPanel("GameOver", [displayName, by.launcher.displayName, by.displayName])
	EffectController.create(ComponentManager.getEffect("DeadBlood"), texture.global_position).shot()
	await die()
	died.emit()
	queue_free()
func tryHeal(count: float):
	if inventory[ItemStore.ItemType.APPLE] > 0 and health < fields.get(FieldStore.Entity.MAX_HEALTH):
		inventory[ItemStore.ItemType.APPLE] -= 1
		playSound("heal")
		healed.emit(heal(count * fields.get(FieldStore.Entity.HEAL_ABILITY)))
		healthChanged.emit(health)
func findWeaponAnchor(weaponName: String) -> Vector2:
	var anchor = $"%weapons".get_node_or_null(weaponName)
	if anchor is Node2D:
		return anchor.global_position
	else:
		return Vector2.ZERO
func setBoss(boss: EntityBase):
	currentFocusedBoss = boss
	if isPlayer() and boss and UIState.bossbar.entity != boss:
		UIState.bossbar.entity = boss
		boss.healthChanged.emit(boss.health)
func playSound(type: String):
	var body = sounds.get_node_or_null(type)
	if body is AudioStreamPlayer2D:
		var cloned = body.duplicate() as AudioStreamPlayer2D
		add_child(cloned)
		cloned.play()
		await cloned.finished
		cloned.queue_free()
func tryKill():
	kill()
	await tryDie()
func hasItem(items: Dictionary):
	for item in items:
		if inventory[item] < items[item]:
			return false
	return true
func useItem(items: Dictionary):
	var state = hasItem(items)
	if state:
		for item in items:
			inventory[item] -= items[item]
	return state
func getItem(items: Dictionary):
	for item in items:
		inventory[item] = clamp(inventory[item] + items[item], 0, inventoryMax[item])

func getTrackingAnchor() -> Vector2:
	return hurtbox.get_node("hitbox").global_position

# 关于分组
func isPlayer():
	return is_in_group("players")

# 抽象方法，实际上是一些钩子，不需要全部实现
func ai():
	pass
func sprintAi():
	velocity *= 0.9
	return velocity.length() <= 100
func attack(_type: int):
	pass
func die():
	pass
func sprint():
	pass
func heal(count: float):
	health += count
	DamageLabel.create(-count, false, damageAnchor.global_position + MathTool.randv2_range(GameRule.damageLabelSpawnOffset))
	return count
func register():
	pass
func spawn():
	pass
func exitStage(_stage: int):
	pass
func enterStage(_stage: int):
	pass
func kill():
	pass

static func generate(
	entity: PackedScene,
	spawnPosition: Vector2,
	isMob: bool = true,
	spawnAsBoss: bool = false,
	addToWorld: bool = true
):
	var instance: EntityBase = entity.instantiate()
	instance.position = spawnPosition
	instance.isBoss = spawnAsBoss
	instance.level = clamp((round(Wave.current * (1 + GameRule.entityLevelOffsetByWave * randf_range(-1, 1)))), 1, INF)
	if isMob:
		instance.add_to_group("mobs")
	if addToWorld:
		WorldManager.rootNode.add_child(instance)
	return instance
static func mobCount():
	return len(WorldManager.tree.get_nodes_in_group("mobs"))
