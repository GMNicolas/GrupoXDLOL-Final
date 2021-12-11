extends KinematicBody2D

class_name Enemy

"""
This implements a very rudimentary state machine. There are better implementations
in the AssetLib if you want to make something more complex. Also it shares code with Enemy.gd
and probably both should extend some parent script
"""

export(int) var WALK_SPEED = 350
export(int) var ROLL_SPEED = 1000
export(int) var hitpoints = 3

var despawn_fx = preload("res://scenes/misc/DespawnFX.tscn")

var linear_vel = Vector2()
export(String, "up", "down", "left", "right") var facing = "down"

var anim = ""
var new_anim = ""

enum { STATE_IDLE, STATE_WALKING, STATE_ATTACK, STATE_ROLL, STATE_DIE, STATE_HURT }

var state = STATE_IDLE

func _ready():
	randomize()

func _physics_process(_delta):
	
	match state:
		STATE_IDLE:
			new_anim = "idle_" + facing
		STATE_WALKING:
			linear_vel = move_and_slide(linear_vel)
			
			var target_speed = Vector2()
			
			if facing == "down":
				target_speed += Vector2.DOWN
			if facing == "left":
				target_speed += Vector2.LEFT
			if facing == "right":
				target_speed += Vector2.RIGHT
			if facing == "up":
				target_speed += Vector2.UP
			
			target_speed *= WALK_SPEED
			linear_vel = linear_vel.linear_interpolate(target_speed, 0.9)
			
			new_anim = ""
			if abs(linear_vel.x) > abs(linear_vel.y):
				if linear_vel.x < 0:
					facing = "left"
				if linear_vel.x > 0:
					facing = "right"
			if abs(linear_vel.y) > abs(linear_vel.x):
				if linear_vel.y < 0:
					facing = "up"
				if linear_vel.y > 0:
					facing = "down"
			
			if linear_vel != Vector2.ZERO:
				new_anim = "walk_" + facing
			else:
				state = STATE_IDLE
			pass
		STATE_ATTACK:
			new_anim = "slash_" + facing
			pass
		STATE_ROLL:
			linear_vel = move_and_slide(linear_vel)
			var target_speed = Vector2()
			if facing == "up":
				target_speed.y = -1
			if facing == "down":
				target_speed.y = 1
			if facing == "left":
				target_speed.x = -1
			if facing == "right":
				target_speed.x = 1
			target_speed *= ROLL_SPEED
			linear_vel = linear_vel.linear_interpolate(target_speed, 0.9)
			new_anim = "roll"
			pass
		STATE_DIE:
			new_anim = "die"
		STATE_HURT:
			new_anim = "hurt"
	


	if new_anim != anim:
		anim = new_anim
		$anims.play(anim)
	pass


func goto_idle():
	state = STATE_IDLE

func _on_state_changer_timeout():
	$state_changer.wait_time = rand_range(1.0, 5.0)
	#state = randi() %3
	state = STATE_ATTACK
	facing = ["left", "right", "up", "down"][randi()%3]
	pass # Replace with function body.


func _on_hurtbox_area_entered(area):
	if state != STATE_DIE and area.name == "player_sword":
		hitpoints -= 1
		var pushback_direction = (global_position - area.global_position).normalized()
		move_and_slide( pushback_direction * 5000)
		state = STATE_HURT
		$state_changer.start()
		if hitpoints <= 0:
			$state_changer.stop()
			state = STATE_DIE
	pass # Replace with function body.

func despawn():
	var despawn_particles = despawn_fx.instance()
	get_parent().add_child(despawn_particles)
	despawn_particles.global_position = global_position
	if has_node("item_spawner"):
		get_node("item_spawner").spawn()
	queue_free()
	pass
