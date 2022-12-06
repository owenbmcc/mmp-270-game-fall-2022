extends Area2D

export var item_type = "apple"
var is_collected = false
signal item_collected

func _on_body_entered(body):
	if not is_collected:
		$AnimatedSprite.play("Collected")
		$ItemCollectedSound.play()
		is_collected = true
		emit_signal("item_collected", item_type)

func _on_animation_finished():
	if is_collected:
		queue_free()
