@tool
extends FullscreenPanelBase

@onready var box = $"%box"

func beforeOpen():
	for weapon in UIState.player.weapons:
		UIState.player.weaponStore.remove_child(weapon)
		box.add_child(weapon)
func afterClose():
	for weapon in box.get_children():
		box.remove_child(weapon)
		UIState.player.weaponStore.add_child(weapon)
