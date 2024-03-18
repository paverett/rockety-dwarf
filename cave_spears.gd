extends StaticBody2D

@export var cave_speed = 100;
var screen_size
var velocity

func _ready():
	screen_size = get_viewport_rect().size
	velocity = Vector2.ZERO
	$TopSpear.disabled = false
	$BottomSpear.disabled = false

func _process(delta):
	velocity.x = cave_speed
	position -= velocity * delta

func set_spears_position(x, y, point_position):
	position.x = x
	$TopSpear.polygon[2].y = point_position
	var top_occluder = LightOccluder2D.new()
	var top_occluder_polygon = OccluderPolygon2D.new()
	top_occluder_polygon.set_polygon($TopSpear.polygon)
	top_occluder.set_occluder_polygon(top_occluder_polygon)
	add_child(top_occluder)
	
	$BottomSpear.polygon[0].y = y
	$BottomSpear.polygon[1].y = y
	$BottomSpear.polygon[2].y = point_position + 100
	var bottom_occluder = LightOccluder2D.new()
	var bottom_occluder_polygon = OccluderPolygon2D.new()
	bottom_occluder_polygon.set_polygon($BottomSpear.polygon)
	bottom_occluder.set_occluder_polygon(bottom_occluder_polygon)
	add_child(bottom_occluder)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func freeze():
	cave_speed = 0;
