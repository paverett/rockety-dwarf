extends Node

@export var cave_spears_scene: PackedScene
@export var counter_scene: PackedScene
@export var enemy_scene: PackedScene

signal new_game_started
signal freeze_game
signal send_the_troops
signal blind_the_troops

var rng = RandomNumberGenerator.new()
var score
var scroll_x = 50
var background_scroll = true
var light_area = 0
var cooldown = 0
var screen_vertices

func _ready():
	background_scroll = false
	screen_vertices = get_viewport().get_visible_rect()

func _process(delta):
	if background_scroll:
		$CaveBackground.scroll_offset.x -= scroll_x * delta
	if (light_area >= 10):
		send_the_troops.emit()
	if (light_area < 10):
		blind_the_troops.emit()
	$hud.update_light_meter(abs(light_area))
	$hud.update_light_cooldown(cooldown)
	$hud.update_frames(Engine.get_frames_per_second())

func game_over():
	set_process(false)
	$Player.freeze_player()
	freeze_game.emit()
	$CaveSpearTimer.stop()
	background_scroll = false
	$hud.show_game_over()
	
func add_score():
	score += 1
	
func new_game():
	set_process(true)
	background_scroll = true
	new_game_started.emit()
	$CaveSpearTimer.start()
	light_area = 0
	score = 0
	$hud.update_score(0)
	$Player.start($BatSpawn.position)

func _on_cave_spear_timer_timeout():
	var cave_spears = create_cave_spear()
	var counter = create_counter()
	var enemy = create_enemy()
	add_child(cave_spears, true)
	add_child(counter, true)
	add_child(enemy, true)

func _on_player_hit():
	game_over()

func _on_player_score():
	add_score()
	$hud.update_score(score)

func _on_player_light(light, light_cooldown):
	light_area = light
	cooldown = light_cooldown
	
func create_cave_spear():
	var cave_spears = cave_spears_scene.instantiate()
	var spears_freeze = Callable(cave_spears, "freeze")
	freeze_game.connect(spears_freeze)
	var free_spears = Callable(cave_spears, "queue_free")
	new_game_started.connect(free_spears)
	cave_spears.set_spears_position(screen_vertices.end.x, 
	screen_vertices.end.y, 
	rng.randi_range(100, screen_vertices.end.y - 200))
	return cave_spears

func create_counter():
	var counter = counter_scene.instantiate()
	var counter_freeze = Callable(counter, "freeze")
	freeze_game.connect(counter_freeze)
	var free_counter = Callable(counter, "queue_free")
	new_game_started.connect(free_counter)
	counter.set_counter_position(screen_vertices.end.x)
	return counter
	
func create_enemy():
	var enemy = enemy_scene.instantiate()
	var awaken_enemy = Callable(enemy, "awaken")
	send_the_troops.connect(awaken_enemy)
	var blind_enemy = Callable(enemy, "blind_em")
	blind_the_troops.connect(blind_enemy)
	var enemy_freeze = Callable(enemy, "freeze")
	freeze_game.connect(enemy_freeze)
	var free_enemy = Callable(enemy, "queue_free")
	new_game_started.connect(free_enemy)
	enemy.set_enemy_position(screen_vertices.end.x + 115)
	return enemy
