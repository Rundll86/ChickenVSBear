extends EffectController

func register():
    particles.texture = load("res://resources/bullets/HXD/effect/%d.png" % randi_range(0, 4))
