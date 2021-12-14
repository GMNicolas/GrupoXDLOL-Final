extends Area2D



func _ready():
	pass



export(String) var required_item = "Cortadora de pasto"
export(int) var required_amount = 1




func _on_body_entered(body):
	if Inventory.get_item(required_item) >= required_amount:
		Inventory.remove_item(required_item, required_amount)
		get_tree().change_scene("res://scenes/levels/Win.tscn")
		
