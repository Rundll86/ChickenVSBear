@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["time"] /= 1 + 0.05 * to * soulLevel
	origin["atk"] *= 2 * to * soulLevel
