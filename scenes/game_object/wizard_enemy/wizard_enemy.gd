extends CharacterBody2D


const MAX_SPEED = 40

@onready var visuals: Node2D = $Visuals
@onready var velocity_component = %VelocityComponent


func _process(delta):
	
	velocity_component.accelerate_to_player()
	velocity_component.move(self)

	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
