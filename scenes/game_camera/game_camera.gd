extends Camera2D

var target_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 10))


func acquire_target():
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player:CharacterBody2D = player_nodes[0]
		#var player = player_nodes[0] as CharacterBody2D another way to do that is to cast it as CharacterBody2D or Node2D is actually what we wanted but whatever you need or want here
		#global_position = player.global_position would make the camera instantly follow the character, not super smooth
		target_position = player.global_position
