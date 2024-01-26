extends Node

#@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")


func _ready():
	upgrade_pool.add_item(upgrade_axe, 10)  # keep in mind these weights can be made to balance the game.  Higher weight = greater chance it will be chosen.
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	upgrade_pool.add_item(upgrade_sword_rate, 10)
	
	experience_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade: AbilityUpgrade):
	for i in upgrade_pool.items.size():
		#var value = upgrade_pool[key]
		print("Upgrade pool inside apply_upgrade ")
		print(upgrade_pool.items[i].item) 
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	#print(current_upgrades)
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id:  #could check if they are equal without id, but if you have duplicated the item it could end up not equal because it compares the references.  Checking id's are equal ensures we find what we're looking for
		upgrade_pool.add_item(upgrade_axe_damage, 10) # keep in mind these weights can be made to balance the game.  Higher weight = greater chance it will be chosen.
		

func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	#var filtered_upgrades = upgrade_pool.duplicate()  # Old way of doing this
	for i in 2:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
	#print("Upgrades: "  )
	#print(current_upgrades )
	#print("Level: " + str(current_level))
	#for i in upgrade_pool.items.size():
		##var value = upgrade_pool[key]
		#print(upgrade_pool.items[i])


func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
