extends StaticBody2D

export var frame_number = 0

func _ready():
	$Sprite.frame = frame_number


func _on_HitArea_body_entered(body):
	body.enemy_collision()
