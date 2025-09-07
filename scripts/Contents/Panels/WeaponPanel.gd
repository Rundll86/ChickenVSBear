@tool
extends FullscreenPanelBase

@onready var box = $"%box"

func beforeOpen(_args: Array = []):
	for weapon in UIState.player.weapons:
		weapon.show()
		UIState.player.weaponStore.remove_child(weapon)
		box.add_child(weapon)
func afterClose():
	for weapon in box.get_children():
		weapon.hide()
		box.remove_child(weapon)
		UIState.player.weaponStore.add_child(weapon)
