extends Node

const SPAWN_RADIUS = 375

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: Node
@export var arena_difficulty_time_decrease: float = .05

#@onready var entities_layer: CanvasGroup = entities
@onready var timer: Timer = $Timer

var base_spawn_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func on_timer_timeout():
	timer.start()  # Restarting timer after wait time changed on difficulty increase.  so we set it to a one shot and then we manually start the timer
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	
	var enemy = basic_enemy_scene.instantiate() as Node2D
	
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
#	could look if the layer exists in case of the layer not being there for some reason
	entities_layer.add_child(enemy)
	#get_parent().add_child(enemy)
	enemy.global_position = spawn_position

func on_arena_difficulty_increased(arena_difficulty_level: int):
	var max_time_off = .5
	#var time_off = (.1 / 12) * arena_difficulty_level
	#timer.wait_time -= time_off
	#print(time_off)
	# how tutorial did the time off above
	var time_off = arena_difficulty_level * arena_difficulty_time_decrease
	print(time_off)
	#time_off = max(time_off, .3) this was his as well.  Not sure about this one
	timer.wait_time = max((base_spawn_time - time_off), .5)
	print(timer.wait_time)
