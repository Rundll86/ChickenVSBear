@tool
extends PanelContainer
class_name Feed

@export var avatarTexture: Texture2D = null
@export var displayName: String = "未命名饲料"
@export var fields: Array[FieldStore.Entity] = []
@export var values: Array[float] = []
@export var costs: Array[ItemStore.ItemType] = []
@export var counts: Array[int] = []

@onready var avatar: TextureRect = $"%avatar"
@onready var nameLabel: Label = $"%name"
@onready var fieldsBox: VBoxContainer = $"%fields"
@onready var costsBox: VBoxContainer = $"%costs"
