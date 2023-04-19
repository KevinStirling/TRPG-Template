extends CanvasLayer

func _process(delta):
	if Input.is_action_just_released("console"):
		visible = !visible
