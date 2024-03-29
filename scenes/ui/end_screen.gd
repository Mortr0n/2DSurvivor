extends CanvasLayer

@onready var panel_container = %PanelContainer

func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	panel_container.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	
	
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart_button_pressed)	 # This may not be accurate, but I think I don't need both the $ and the % like in the videos $%
	%QuitButton.pressed.connect(on_quit_button_pressed)


func play_jingle(defeat: bool = false):
	if defeat:
		$DefeatStreamPlayer2.play()
	else:
		$VictoryStreamPlayer.play()

func set_defeat():
	%TitleLabel.text = "Defeat"
	%DescriptionLabel.text = "You Lose"
	play_jingle(true)

func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	


func on_quit_button_pressed():
	get_tree().quit()
