extends CharacterBody2D


const MAX_SPEED = 40

@onready var visuals: Node2D = $Visuals
@onready var velocity_component = %VelocityComponent

var is_moving = true # I turned this on and off with the animation player.  Does not fit this enemy, but I like the idea.  a slug or snail or something would fit the movement turning on and off.

func _ready():
	$HurtboxComponent.hit.connect(on_hit)


func _process(delta):
	velocity_component.accelerate_to_player() # see the other notes about starting and stopping.  also see the animation for this enemy for adding the function
	#if is_moving:
		#velocity_component.accelerate_to_player()
	#else:
		#velocity_component.decelerate()
	
	velocity_component.move(self)

	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func set_is_moving(moving: bool): #use this idea for an enemy that starting and stopping movement via the animation player will fit better.
	is_moving = moving


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()
