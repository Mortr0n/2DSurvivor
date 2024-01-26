extends Node

const SPAWN_RADIUS = 375

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: Node
@export var arena_difficulty_time_decrease: float = .05

#@onready var entities_layer: CanvasGroup = entities
@onready var timer: Timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()


func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	#enemy_table.add_item(wizard_enemy_scene, 1)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


#func get_spawn_position(timesRun: int): # when I take over look to pass in the player: CharacterBody2D Not sure I want to look for it twice.
func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		# we are checking if there would be a wall collision between the enemy and the player using ray tracing.
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
		var collision_result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if collision_result.size() == 0:
			return spawn_position
		else:
			random_direction = random_direction.rotated(1.5708) # It's in radians.  I just converted 90 deg, but there is a deg_to_rad, but is it worth the extra calc???
	#if timesRun < 4:
		#return get_spawn_position(timesRun + 1)
	return Vector2.ZERO


func on_timer_timeout():
	timer.start()  # Restarting timer after wait time changed on difficulty increase.  so we set it to a one shot and then we manually start the timer
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	#var enemy = basic_enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
#	could look if the layer exists in case of the layer not being there for some reason
	entities_layer.add_child(enemy)
	#get_parent().add_child(enemy)
	enemy.global_position = get_spawn_position()

func on_arena_difficulty_increased(arena_difficulty_level: int):
# TODO: Should decide what enemies get spawned at what timer on top of just having the enemy weights or we could use the enemy weight to actually add them in that order. 
# TODO: Don't forget special and/or boss mobs as well.  Have to spice things up a bit!!!
	if arena_difficulty_level >= 1:
		#print("arena difficulty greater than 3 = " + str(arena_difficulty_level))
		enemy_table.add_item(wizard_enemy_scene, 1)
	var max_time_off = .5
	#var time_off = (.1 / 12) * arena_difficulty_level
	#timer.wait_time -= time_off
	#print(time_off)
	# how tutorial did the time off above
	var time_off = arena_difficulty_level * arena_difficulty_time_decrease
	#print(time_off)
	#time_off = max(time_off, .3) this was his as well.  Not sure about this one
	timer.wait_time = max((base_spawn_time - time_off), .5)
	#print(timer.wait_time)
