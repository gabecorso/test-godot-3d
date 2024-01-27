extends CharacterBody3D

#emitted when a player is hit by a mob
signal hit
# player movement in meters per second
@export var speed = 14

# downward acceleration in air, m/s(2)
@export var fall_acceleration = 75

#vertical impulse applied to character upon jumping, in m/s
@export var jump_impulse = 20

# vertical impulse applied to the player upon bouncing over a mob in m/s
@export var bounce_impulse = 14


var target_velocity = Vector3.ZERO

func _physics_process(delta):
	#store input direction 3D vector locally
	var direction = Vector3.ZERO
	
	#check inputs and update the direction accordingly
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		# xz is the ground plane in 3d, so we use x and z for grounded movement
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		
		direction = direction.normalized() #normalize the vector to account for diagonal movement 
		# setting the basis property will affect the rotation of the node
		$Pivot.basis = Basis.looking_at(direction)
		
		$AnimationPlayer.speed_scale = 2.5
	else:
		$AnimationPlayer.speed_scale = 1
	#ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# vertical velocity
	if not is_on_floor(): # if in the air, fall to the floor, implement gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# moving the character 
	velocity = target_velocity
	
	# jumping
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	#iterate through all the collisions that occured this frame
	for index in range(get_slide_collision_count()):
		# get a collision with the player
		var collision = get_slide_collision(index)
		
		#if the collision is with the gorund
		if collision.get_collider() == null:
			continue
			
		# if the collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			#check we are hitting above using a dot product
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# squash and bounce
				mob.squash()
				target_velocity.y = bounce_impulse
				# prevent duplicate calls
				break
	move_and_slide()
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	die()


