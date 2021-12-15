extends Area2D



func _ready():
	pass



export(String) var required_item = "Podadora"
export(int) var required_amount = 1


func _on_win_body_entered(body):
	if Inventory.get_item("Podadora") >= required_amount:
		Inventory.remove_item("Podadora", required_amount)
	if body is Player:
		get_tree().change_scene("res://scenes/levels/Win.tscn")
	pass # Replace with function body.
