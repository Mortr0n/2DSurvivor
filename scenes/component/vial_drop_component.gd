extends Node

@export_range(0, 1) var drop_percent: float = .01
@export var health_component: Node
@export var vial_scene: PackedScene

func _ready():
	(health_component as HealthComponent).died.connect(on_died)
	

func on_died():
	#var test = randf()
	#print(test > drop_percent)
	if randf() > drop_percent:
		return
	
	if vial_scene == null:
		return
	
	if not owner is Node2D:
		return
		
	var spawn_position = (owner as Node2D).global_position
	var vial_instance = vial_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(vial_instance)	
	#owner.get_parent().add_child(vial_instance) original way of doing it before we added the extra layer.  It was this way in basic_enemy as well.
	vial_instance.global_position = spawn_position
