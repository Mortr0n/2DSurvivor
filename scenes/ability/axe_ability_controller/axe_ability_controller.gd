extends Node

@export var axe_ability_scene: PackedScene

var base_damage = 10
var additional_damage_percent = 1
var damage_power = 1

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	if foreground_layer == null:
		return
	
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground_layer.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = base_damage * pow(additional_damage_percent, damage_power)
	
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	#print("ID: " + upgrade.id + "Name: " + upgrade.name + "Desc: " + upgrade.description)
	if  upgrade.id == "axe_damage":
		#additional_damage_percent = 1 + (current_upgrades["axe_damage"]["quantity"] * .10)
		damage_power = current_upgrades["axe_damage"]["quantity"] 
		additional_damage_percent = 1.10
