extends Node

@export var end_screen_scene: PackedScene

func  _ready():
	%Player.health_component.died.connect(on_player_died)
	

func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)  # tutorial said this has to come before the set_defeat item.  I did it the other way around and it worked fine.
	end_screen_instance.set_defeat() # I just don't want to take a chance of a bug creeping up later from it.  This may be something they changed with my version of Godot
	
