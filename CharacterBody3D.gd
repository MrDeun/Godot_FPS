extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var light = $hit

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func got_hit():
	light.light_energy = 5.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
	#	velocity.x = direction.x * SPEED
	#	velocity.z = direction.z * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	#	velocity.z = move_toward(velocity.z, 0, SPEED)
	light.light_energy = max(0,light.light_energy - delta*10)
	move_and_slide()
