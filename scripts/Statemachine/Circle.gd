@tool
extends Control
class_name Circle

@export var cyclotomy: int = 32
@export var avatar: Texture2D = null
@export var backgroundColor: Color = Color(0, 0, 0, 0.5)
@export var borderColor: Color = Color(0.2, 0.2, 0.2)
@export var borderWidth: int = 5

@onready var polygon: Polygon2D = $"%polygon"
@onready var texture: TextureRect = $"%texture"
@onready var background: PanelContainer = $"%background"

var backgroundBox: StyleBoxFlat = null

func _ready():
	backgroundBox = StyleBoxFlat.new()
	background.add_theme_stylebox_override("panel", backgroundBox)
func _process(_delta):
	var radius = max(size.x, size.y) / 2
	size = Vector2(radius * 2, radius * 2)
	polygon.polygon = getPolygon(radius)
	polygon.position = size / 2
	backgroundBox.bg_color = backgroundColor
	backgroundBox.border_color = borderColor
	backgroundBox.corner_radius_top_left = radius
	backgroundBox.corner_radius_top_right = radius
	backgroundBox.corner_radius_bottom_left = radius
	backgroundBox.corner_radius_bottom_right = radius
	backgroundBox.border_width_top = borderWidth
	backgroundBox.border_width_bottom = borderWidth
	backgroundBox.border_width_left = borderWidth
	backgroundBox.border_width_right = borderWidth
	background.size = size
	texture.size = Vector2(radius * 2, radius * 2)
	texture.position = - Vector2(radius, radius)
	if avatar:
		texture.texture = avatar
func getPolygon(radius: float):
	var result: Array[Vector2] = []
	for i in cyclotomy:
		var angle = i * (TAU / cyclotomy)
		var x = (radius - borderWidth) * cos(angle)
		var y = (radius - borderWidth) * sin(angle)
		result.append(Vector2(x, y))
	return result
