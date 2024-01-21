extends Node2D
const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent

var base_rotation = Vector2.RIGHT


func _ready():
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var tween = create_tween()
	# tween_method = method to call, starting value, ending value, duration of animation
	tween.tween_method(tween_method, 0.0, 2.0, 3.0) # without putting the decimals in there it thought we had ints instead of floats and did not animate correctly.
	tween.tween_callback(queue_free) # can queue up another function call after the tween_method finishes tweening.  that's tweentastic!


func tween_method(rotations: float):
	var percent = rotations / 2  #we're doing 2 rotations so need to find the percent around the rotation
	var current_radius = percent * MAX_RADIUS # how far along in the radius we are percent times total radius 
	var current_direction = base_rotation.rotated(rotations * TAU) # TAU 2 times pie or the total circumference of a circle in radians.  we want 2 rotations so 2 times 2 times pie or 2 * TAU
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return	
		
	global_position = player.global_position + (current_direction * current_radius)
