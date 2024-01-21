extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D

@onready var gpu_particles: GPUParticles2D = $GPUParticles2D

func _ready():
	var gpu_particles_texture = gpu_particles.texture
	health_component.died.connect(on_died)
	

func on_died():
	if owner == null || not owner is Node2D:
		return
	var spawn_position = owner.global_position
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	
	entities_layer.add_child(self)
	
	global_position = spawn_position
	$AnimationPlayer.play("default")
	
