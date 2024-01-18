extends Node
#class_name GameEvents

signal experience_vial_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)

func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	#print(current_upgrades)
	#print(upgrade)
	ability_upgrade_added.emit(upgrade, current_upgrades)
