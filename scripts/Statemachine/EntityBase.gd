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
@export var useStatic: bool = false
@export var hurtAudioRate: float = 1

@onready var animatree: AnimationTree = $"%animatree"
@onready var texture: AnimatedSprite2D = $"%texture"
@onready var hurtbox: Area2D = $"%hurtbox"
@onready var sounds: Node2D = $"%sounds"
@onready var hurtAnimator: AnimationPlayer = $"%hurtAnimator"
@onready var stageAnimator: AnimationPlayer = $"%stageAnimator"
@onready var damageAnchor: Node2D = $"%damageAnchor"
@onready var trailParticle: GPUParticles2D = $"%trailParticle"
@onready var weaponStore: Node2D = $"%weaponStore"
@onready var syncer: MultiplayerSynchronizer = $"%syncer"
var statebar: EntityStateBar

@export var health: float = 0
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
	if useStatic:
		texture = texture.get_node("staticAnimation")
	spawnTime = WorldManager.getTime()
	register()
	var selfStatebar: EntityStateBar = $"%statebar"
	if isBoss:
		selfStatebar.hide()
	else:
		statebar = selfStatebar
		statebar.entity = self
	if isPlayer():
		if displayName == MultiplayerState.playerName:
			UIState.player = self
		for i in weaponStore.get_children():
			i.hide()
			weapons.append(i)
			weaponBag.append(i.displayName)
		statebar.levelLabels.hide()
		energyChanged.connect(
			func(newEnergy, dontChangeDirection):
				if !UIState.player == self: return
				UIState.energyPercent.maxValue = fields.get(FieldStore.Entity.MAX_ENERGY)
				if dontChangeDirection:
					UIState.energyPercent.currentValue = newEnergy
				else:
					UIState.energyPercent.setCurrent(newEnergy)
		)
		if displayName == MultiplayerState.playerName:
			rebuildWeaponIcons()
	else:
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
	if !isPlayer() && !currentFocusedBoss:
		currentFocusedBoss = MathTool.randc_from(get_tree().get_nodes_in_group("players"))
	animatree.set("parameters/blend_position", lerpf(animatree.get("parameters/blend_position"), lastDirection, 0.2))
	if sprinting:
		if sprintAi():
			sprinting = false
	else:
		velocity = Vector2.ZERO
		if (isPlayer() or is_instance_valid(currentFocusedBoss)) and not charginup and canRunAi:
			if isPlayer():
				if MultiplayerState.playerName == displayName or not MultiplayerState.isMultiplayer:
					ai()
			else:
				ai()
		elif isSummon():
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
	fields[FieldStore.Entity.MAX_HEALTH] *= (1 + GameRule.entityHealthIncreasePerWave * (GameRule.difficulty - GameRule.difficultyRange.x + 5)) ** level
	fields[FieldStore.Entity.DAMAGE_MULTIPILER] *= sqrt((1 + GameRule.entityDamageIncreasePerWave * (GameRule.difficulty - GameRule.difficultyRange.x))) ** level
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
func takeDamage(baseDamage: float, crit: bool = false, perfectMiss: bool = false):
	var resultDamage = baseDamage + baseDamage * int(crit) * fields.get(FieldStore.Entity.CRIT_DAMAGE)
	health -= resultDamage
	healthChanged.emit(health)
	DamageLabel.create(resultDamage, crit || perfectMiss, damageAnchor.global_position + MathTool.randv2_range(GameRule.damageLabelSpawnOffset))
	if health <= 0:
		tryDie(null)
	return resultDamage
func bulletHit(bullet: BulletBase, crit: bool):
	# 当受伤时
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
		if MathTool.rate(hurtAudioRate):
			playSound("hurt")
		storeEnergy(damage * -0.5)
	position += Vector2.from_angle(bullet.position.angle_to_point(position)) * bullet.knockback
	hit.emit(damage, bullet, crit)
	health -= damage
	healthChanged.emit(health)
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
	if isPlayer() and !isSummon():
		if len(weapons) > type:
			weapon = weapons[type]
		else:
			return
	var state
	if isPlayer() and !isSummon():
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
		if isPlayer() and !isSummon():
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
				ItemDropped.generate(item, randi_range(1, int(sqrt(count) * (GameRule.difficulty - GameRule.difficultyRange.x + 1))), position + MathTool.randv2_range(GameRule.itemDroppedSpawnOffset))
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
	if isBoss:
		ItemDropped.generate(
			ItemStore.ItemType.SOUL,
			randi_range(1, 2),
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
func summon(who: PackedScene, syncFields: bool = true, lockValue: bool = true) -> SummonBase:
	var instance: SummonBase = who.instantiate()
	instance.position = position
	instance.myMaster = self
	if isPlayer(): instance.add_to_group("players")
	if syncFields:
		if lockValue:
			instance.fields = fields.duplicate()
		else:
			instance.fields = fields
	get_parent().add_child(instance)
	return instance

# 关于追踪
func getTrackingAnchor() -> Vector2:
	return hurtbox.get_node("hitbox").global_position

# 关于实体类型
func isPlayer() -> bool:
	return is_in_group("players")
func isSummon() -> bool:
	return self is SummonBase

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

static func findPlayer(playerName: String) -> EntityBase:
	for i in WorldManager.tree.get_nodes_in_group("players"):
		if i.displayName == playerName:
			return i
	return null
static func generatePlayer(playerName: String) -> EntityBase:
	var player = generate(ComponentManager.getCharacter("Rooster"), Vector2.ZERO, false)
	player.displayName = playerName
	player.name = "Player_%s" % playerName
	return player
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
	else:
		instance.add_to_group("players")
	if addToWorld:
		WorldManager.rootNode.spawn(instance)
	return instance
static func mobCount():
	return len(WorldManager.tree.get_nodes_in_group("mobs"))
