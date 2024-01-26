extends CharacterBody2D


@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar # should instead get by group or something else instead of naming the node and grabbing it that way see link below
@onready var ability_manager = $AbilityManager
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent


var number_colliding_bodies = 0
var base_speed = 0

func _ready():
	base_speed = velocity_component.max_speed
#Putting this comment in here, because relying on node names is generally a bad practice. 
#instead you should use groups or classes. see link for more on this. https://www.reddit.com/r/godot/comments/14std39/nodename_not_returning_the_correct_name_after/ 
# could check if it's in the enemies group or define an enemy class and look for that. If you're at this point congratulations for getting far enough to do your own thing!  
# You're Amazing!  Keep Learning!
	$EnemyCollisionArea2D.body_entered.connect(on_body_entered) #signals need a .connect
	$EnemyCollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()



func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	#var target_velocity = (direction * MAX_SPEED)
	#velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()
	
	if movement_vector.x != 0 || movement_vector.y != 0: # which animation to play
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	var move_sign = sign(movement_vector.x) # animation directions returns the .x which will be a -1 for left, 1 for right or 0 for not moving
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1) #setting x cordinate of the scale of the visual to match the direction of movement
	


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
	GameEvents.emit_player_damaged()
	update_health_display()
	$HitRandomStreamPlayer.play_random()

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability: Ability = ability_upgrade
		ability_manager.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		var player_speed_quantity = current_upgrades["player_speed"]["quantity"]	
		#print("PSQ = " + str(player_speed_quantity) + " max speed = " + str(velocity_component.max_speed))
		velocity_component.max_speed = base_speed + ((velocity_component.max_speed * .10 )* player_speed_quantity)
		#print(velocity_component.max_speed)
	
	
	
	
	
	
	
	
	
