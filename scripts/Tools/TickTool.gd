class_name TickTool

static func millseconds(ms: float):
	return await WorldManager.tree.create_timer(ms / 1000.0).timeout
static func frame(count: int = 1):
	for i in range(count):
		await WorldManager.tree.physics_frame
static func until(predicate: Callable):
	while not predicate.call():
		await frame.unbind(1).call(0)
static func modifyAnimationKey(animator: AnimationPlayer, name: String, track: NodePath, trackType: Animation.TrackType, time: float, value: Variant):
	var animation = animator.get_animation(name)
	var trackIdx = animation.find_track(track, trackType)
	var keyIdx = animation.track_find_key(trackIdx, time)
	var inHandle
	var outHandle
	if trackType == Animation.TrackType.TYPE_BEZIER:
		inHandle = animation.bezier_track_get_key_in_handle(trackIdx, keyIdx)
		outHandle = animation.bezier_track_get_key_out_handle(trackIdx, keyIdx)
		animation.track_set_key_value(trackIdx, keyIdx, [value, inHandle.x, inHandle.y, outHandle.x, outHandle.y])
	else:
		animation.track_set_key_value(trackIdx, keyIdx, [value])
