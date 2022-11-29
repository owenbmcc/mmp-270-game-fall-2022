extends Area2D

export var dialog_name = "Demo"

var player = null

func _on_NPC_body_entered(body):
	player = body
	player.start_dialog()
	var dialog = Dialogic.start(dialog_name)
	add_child(dialog)
	dialog.connect('timeline_end', self, 'end_dialog')

func end_dialog(_param):
	player.end_dialog()
