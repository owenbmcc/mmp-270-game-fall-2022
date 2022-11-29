extends Area2D

export var item_type = "apple"
var is_collected = false

func _on_body_entered(body):
	if not is_collected:
		$AnimatedSprite.play("Collected")
		$ItemCollectedSound.play()
		is_collected = true

func _on_animation_finished():
	if is_collected:
		queue_free()
