extends CanvasLayer

signal start_game

func _ready():
	$Light.hide()

func _process(delta):
	pass
	
func show_message(text):
	$Message.text = text
	$Message.show()
	
func show_game_over():
	show_message("Game Over")
	$StartButton.text = "Retry"
	$StartButton.show()

func update_score(score):
	$Score.text = str(score)
	
func update_frames(frames):
	$Frames.text = str(frames)
	
func update_light_meter(light_area):
	if (light_area < 7):
		$Light.get("theme_override_styles/fill").set_bg_color(Color(0.0,1.0,0.0,1.0))
	elif (light_area > 7 and light_area < 10):
		$Light.get("theme_override_styles/fill").set_bg_color(Color(1.0,1.0,0.0,1.0))
	elif (light_area > 10):
		$Light.get("theme_override_styles/fill").set_bg_color(Color(1.0,0.0,0.0,1.0))
	$Light.value = light_area

func update_light_cooldown(cooldown):
	$LightCooldown.value = cooldown
	
func _on_start_button_pressed():
	$Message.hide()
	$StartButton.hide()
	$Light.show()
	$LightCooldown.show()
	start_game.emit()
