extends Area2D


onready var HP = 10
onready var sprite = get_node("AnimatedSprite")




func _ready():
	pass 







func _on_caja_entered(area):
	if area.name == "player_sword":
		HP -= 1
	print(HP)
	pass 
