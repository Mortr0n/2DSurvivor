extends Node

const MAX_RANGE = 150

@export var sword_ability: PackedScene

var base_damage = 5
var additional_damage_percent = 1
var base_wait_time
var damage_power = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	#player.get_parent().add_child(sword_instance)  original way of adding the sword to the scene tree.  Now we add to the foreground always from our foreground node
	sword_instance.hitbox_component.damage = base_damage * pow(additional_damage_percent, damage_power)
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
	
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	#print("ID: " + upgrade.id + "Name: " + upgrade.name + "Desc: " + upgrade.description)
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * .1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
	elif upgrade.id == "sword_damage":
		damage_power = current_upgrades["sword_damage"]["quantity"] 
		additional_damage_percent = 1.15
		
	#print($Timer.wait_time)
	
	
	
	
