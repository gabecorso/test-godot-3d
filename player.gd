extends CharacterBody3D

# player movement in meters per second
@export var speed = 14

# downward acceleration in air, m/s(2)
@export var fall_acceleration = 75

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
	
	#ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# vertical velocity
	if not is_on_floor(): # if in the air, fall to the floor, implement gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# moving the character 
	velocity = target_velocity
	move_and_slide()
