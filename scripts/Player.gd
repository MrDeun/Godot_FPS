extends CharacterBody3D

#Players data
var Armor = 0.0
var Health = 100.0


# Movement Constants
const SPEED = 8.8
const JUMP_VELOCITY = 10.0
const MOUSE_SENSITIVITY = 0.01

#Bob camera variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.05
var t_bob = 0.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck := $Neck
@onready var neck_camera := $Neck/PlayerCamera
@onready var gun_raycast := $Neck/PlayerCamera/Crosshair_raycast
@onready var sphere_collision := $"../HighCalibler/Sphere"
@onready var pistol := $Neck/PlayerCamera/weapon_rigging/Pistol
@onready var ammo_count := $Neck/PlayerCamera/HUD/Ammo/HBoxContainer
@onready var decal_scene := preload("res://subscenes/decal.tscn")

func _pistol_fire():
	var fire_success: bool = pistol.shoot()
	if gun_raycast.is_colliding() and fire_success:
		var col_normal = gun_raycast.get_collision_normal()
		var col_point = gun_raycast.get_collision_point()
		var target = gun_raycast.get_collider()
		ammo_count.give_shake()
		if target.name == sphere_collision.name:
			target.green_buln.got_hit()
		else :
			var b_decal = decal_scene.instantiate()
			gun_raycast.get_collider().add_child(b_decal)
			b_decal.global_position = col_point
			if col_normal == Vector3.DOWN:
				b_decal.rotation_degrees.x = 90
			elif col_normal != Vector3.UP:
				b_decal.look_at(col_point - col_normal, Vector3(0,1,0))
			
			
			

func _unhandled_input(event) -> void:
	# Check Mouse Input
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Change camera rotation
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
			neck_camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
			neck_camera.rotation.x = clamp(neck_camera.rotation.x,deg_to_rad(-60),deg_to_rad(60))
		

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized())
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		
	#Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	neck_camera.transform.origin = _headbob(t_bob)
	
	if Input.is_action_pressed("shoot"):
		_pistol_fire() 
	if Input.is_action_pressed("reload"):
		pistol.reload()
				
	move_and_slide()
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO;
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

	

