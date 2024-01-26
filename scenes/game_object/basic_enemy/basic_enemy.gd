extends CharacterBody2D

const MAX_SPEED = 40

@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals: Node2D = $Visuals
@onready var velocity_component = %VelocityComponent


func _ready():
	$HurtboxComponent.hit.connect(on_hit)

func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	# original way of moving to player before making the velocity component
	#var direction = get_direction_to_player()
	#velocity = direction * MAX_SPEED
	#move_and_slide()

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO

func on_hit():
	$HitRandomAudioPlayerComponent.play_random()
	#$AudioStreamPlayer2D.play()
# Damage was originally called from the enemy, but now we've updated so that a Hitbox/Hurtbox collision causes damage
# Leaving the original 2 functions that we're handling the damage in from the enemy 
#func _ready():
	#$Area2D.area_entered.connect(on_area_entered)
#func on_area_entered(other_area: Area2D):
	#health_component.damage(5)
