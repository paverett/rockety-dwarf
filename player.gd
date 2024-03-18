extends Area2D

signal hit
signal score
signal light(light_area, cooldown)

@export var jump_speed = -300.0
var velocity

func _ready():
	velocity = Vector2.ZERO
	$Body.disabled = true
	hide()

func _physics_process(delta):
	velocity.y += gravity * delta
	if Input.is_action_just_pressed("flap"):
		$Cart.play("fly")
		velocity.y = jump_speed

func _process(delta):
	position += velocity * delta
	if ($LampTimer.is_stopped() and $Lamp.texture_scale > .5):
		$Lamp.texture_scale -= 2 * delta
	if (!$LampTimer.is_stopped()):
		$Lamp.texture_scale += 3 * delta
	if ($LampTimer.is_stopped()):
		if Input.is_action_just_pressed("light"):
			$LampTimer.start()
	light.emit($Lamp.texture_scale, $LampTimer.time_left)

func start(pos):
	set_process(true)
	set_physics_process(true)
	position = pos
	$Cart.play("float")
	$Body.disabled = false
	show()
	$Lamp.texture_scale = 7
	velocity.y = jump_speed

func _on_body_entered(body):
	var layer = body.get_collision_layer()
	if (layer == 1):
		hit.emit()

func _on_body_exited(body):
	var layer = body.get_collision_layer()
	if (layer == 2):
		if (!body.is_queued_for_deletion()):
			score.emit()

func freeze_player():
	set_process(false)
	set_physics_process(false)
	$Cart.stop()

func _on_cart_animation_finished():
	$Cart.play("float")
