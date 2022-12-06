extends Node

export (NodePath) var player_path
onready var player = get_node(player_path)

export (NodePath) var game_over_path
onready var game_over_ui = get_node(game_over_path)

export (NodePath) var win_game_path
onready var win_game_ui = get_node(win_game_path)

export (NodePath) var metrics_ui_path
onready var metrics = get_node(metrics_ui_path)

signal game_over # game over signal for other mechanics

func _ready():
	game_over_ui.visible = false
	win_game_ui.visible = false

func game_over():
	Global.player_lives = Global.total_lives
	game_over_ui.visible = true
	emit_signal("game_over")
	
	# uncomment to play sfx
	# $GameOverSound.play()

func win_game():
	win_game_ui.visible = true
	
	# uncomment to play sfx
	# $WinGameSound.play()
	
func _on_player_hit(is_alive):
	if is_alive:
		Global.player_lives = Global.player_lives - 1
		metrics.update_display()
	if not is_alive or Global.player_lives == 0:
		player.dies()

# update Global based on items, update metrics display
func _on_item_collected(item_type):
	if item_type == 'apple':
		Global.item_count = Global.item_count + 1

	if item_type == 'life' and Global.player_lives < Global.total_lives:
		Global.player_lives = Global.player_lives + 1
	
	metrics.update_display()

func _on_Player_player_dies():
	game_over()
