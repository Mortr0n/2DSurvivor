extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D  # to drag this in grab it from the scene tree and drag to this window then hold control and let go
@onready var sprite = $Sprite2D


var current_experience = 0


func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))
	
	
func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()
	

func disable_collision(): #setting the disabling of the collision shape as a function that we can then call deferred
	collision_shape_2d.disabled = true
	

	
func on_area_entered(other_area: Area2D):
	 # can not modify anything about collision shapes in a signal processing item  need to defer the call to the collision disable to after it's done processing the function that we're calling this from
	Callable(disable_collision).call_deferred() # see the deferred call here
	var tween = create_tween()
	tween.set_parallel()
	# backslashes \ allow you to start code on a new line like below.  Left in for giggles
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, .75)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	 # since the tweens are running in parallel then we delay the animation for .35 seconds so that the animation starts midway through the one running .5 seconds and finishes at the same time with .15 seconds
	tween.tween_property(sprite, "scale", Vector2.ZERO, .15).set_delay(.65)
	
	
	tween.chain()  # since we're running the tweens in parallel we need a way to wait for them to finish before calling the callback to collect and remove the vial from the queue
	tween.tween_callback(collect)
	
	
	


