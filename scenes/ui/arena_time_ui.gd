extends CanvasLayer

@export var arena_time_manager: Node
@onready var label = %Label

func _process(delta):
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	var time_elapsed_string_for_label = format_seconds_to_string(time_elapsed)
	label.text = str(time_elapsed_string_for_label)
	
	
func format_seconds_to_string(seconds: float):
	var minutes = floor(seconds / 60)
	var remaining_seconds = seconds - (minutes * 60)
	#print("seconds: " + str(seconds) + "minutes: " + str(minutes) + "minutes*60: " + str(minutes * 60))
	return str(minutes) + ":" + "%02d" % floor(remaining_seconds)
