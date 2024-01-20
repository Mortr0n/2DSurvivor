extends CharacterBody2D

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 25

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar # should instead get by group or something else instead of naming the node and grabbing it that way see link below

var number_colliding_bodies = 0

func _ready():
#Putting this comment in here, because relying on node names is generally a bad practice. 
#instead you should use groups or classes. see link for more on this. https://www.reddit.com/r/godot/comments/14std39/nodename_not_returning_the_correct_name_after/ 
# could check if it's in the enemies group or define an enemy class and look for that. If you're at this point congratulations for getting far enough to do your own thing!  
# You're Amazing!  Keep Learning!
	$EnemyCollisionArea2D.body_entered.connect(on_body_entered) #signals need a .connect
	$EnemyCollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	update_health_display()



func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = (direction * MAX_SPEED)
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()


func get_movement_vector():
	#var movement_vector = Vector2.ZERO
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)

func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():		
		return
	health_component.damage(1)
	damage_interval_timer.start()
	#print(health_component.current_health)

func update_health_display():
	health_bar.value = health_component.get_health_percent()

#signal connections at bottom of code and prefixed with on to show they are signal connections
func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1	
	check_deal_damage()

func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1	
	check_deal_damage()
	

func on_damage_interval_timer_timeout():
	check_deal_damage()

func on_health_changed():
	update_health_display()
