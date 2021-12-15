extends Area2D


export(String, FILE, "*.tscn") var to_scene = ""
export(String) var spawnpoint = ""


func _ready():
	# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered")
	pass # Replace with function body.

func _on_body_entered(body):
	if body is Player:
		if  to_scene == "":
			push_error("Error changing scenes: to_scene has no assigned scene")
			return false
		Globals.spawnpoint = spawnpoint
		Globals.current_level = to_scene
		if get_tree().change_scene(to_scene) != OK:
			push_error("Error changing scene")
	pass
