extends StaticBody2D

@export var cave_speed = 100;
var screen_size
var velocity

func _ready():
	screen_size = get_viewport_rect().size
	velocity = Vector2.ZERO
	$Counter.disabled = false

func _process(delta):
	velocity.x = cave_speed
	position -= velocity * delta

func set_counter_position(x):
	position.x = x

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func freeze():
	cave_speed = 0;
