extends CharacterBody2D

@export var cave_speed = 100;
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite

var speed = 200
var screen_size
var sleeping
var blind

func _ready():
	set_process(true)
	set_physics_process(true)
	sleeping = true
	screen_size = get_viewport_rect().size
	velocity = Vector2.ZERO
	$EnemyShape.disabled = false

func _process(delta):
	if blind:
		sprite.play("stationary")
	if sleeping:
		sprite.stop()
	if sleeping or blind:
		velocity.x = cave_speed
		position -= velocity * delta
	
func _physics_process(delta):
	velocity = Vector2.ZERO
	if !sleeping and !blind:
		$Sprite.play()
		look_at(player.position)
		velocity = (player.position - position).normalized() * speed
		sprite.play("left")
		move_and_slide()

func set_enemy_position(x):
	position.x = x

func awaken():
	sleeping = false
	blind = false
	
func blind_em():
	blind = true
	
func freeze():
	set_process(false)
	set_physics_process(false)
	$Sprite.stop()

func _on_visible_on_screen_notifier_2d_screen_exited():
	$Timer.start()

func _on_visible_on_screen_notifier_2d_screen_entered():
	$Timer.stop()

func _on_timer_timeout():
	queue_free()
