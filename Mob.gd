extends CharacterBody3D
#emitted when player jumps on mob
signal squashed

# min mob speed in m/s
@export var min_speed = 10
# max speed in m/s
@export var max_speed = 18

func _physics_process(delta):
	move_and_slide()
	
# this will be called from the Main scene
func initialize(start_position, player_position):
	# position the mob by placing it at the start position
	# rotate it towards player position, so it looks at the player
	look_at_from_position(start_position, player_position, Vector3.UP)
	
	# rotate the mob within -45 -> 45 so it doesnt move toward the player directly
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# calculate a random speed in the range (integer)
	var random_speed = randi_range(min_speed, max_speed)
	# calculate forward velocity as speed
	
	velocity = Vector3.FORWARD * random_speed
	
	#rotate the velocity vecor based on the mob's y rotation
	# to move the direction the mob is looking
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
	
func squash():
	squashed.emit()
	queue_free()
