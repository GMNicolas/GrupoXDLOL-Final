extends Area2D


onready var hp = 10
onready var anims =get_node("anims")




func _ready():
	pass 



#< >



func _on_caja_entered(area):
	if area.name == "player_sword":
		hp -= 1
		if hp <= 7 :
			anims.play("7 ")
		if hp <= 4 :
			anims.play("4 ")
		if hp <= 0 :
			anims.play("0 ")
	print(hp)
