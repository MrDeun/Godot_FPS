extends CharacterBody3D

@onready var camera = $first_person_camera
@onready var weapon_camera = $PlayerInterface/SubViewportContainer/SubViewport/weapon_camera

@onready var pistol = $PlayerInterface/SubViewportContainer/SubViewport/weapon_camera/Weapon_Rig/Pistol
@onready var auto = $PlayerInterface/SubViewportContainer/SubViewport/weapon_camera/Weapon_Rig/MachineGun
@onready var gun_raycast = $first_person_camera/hit_trail


var CameraRotation = Vector2(0,0)
var MouseSense = 0.2001
const SPEED = 10.0
const JUMP_VELOCITY = 12.0

var can_shoot = true

enum weapons {
	PISTOL,
	AUTO
}

var current_weapon = weapons.PISTOL

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _fire_auto():
	gun_raycast.position.z *= auto.ray_range
	var fire_success: bool = auto.fire()
	print("AUTO STATUS: " + str(fire_success))
	gun_raycast.position.z /= auto.ray_range
	pass

func _fire_pistol():
	gun_raycast.position.z *= pistol.ray_range
	var fire_success: bool = pistol.shoot()
	gun_raycast.position.z /= pistol.ray_range
	pass

func shoot():
	match current_weapon:
		weapons.AUTO:
			_fire_auto()
		weapons.PISTOL:
			_fire_pistol()
	pass

func _ready():
	activate_weapon(weapons.PISTOL)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func activate_weapon(new_weapon:weapons):
	match new_weapon:
		weapons.PISTOL:
			pistol.activate()
		weapons.AUTO:
			auto.activate()

func switch_weapon(new_weapon: weapons):
	if new_weapon != current_weapon:
		can_shoot = false
		deactivate_weapon()
		activate_weapon(new_weapon)
		await get_tree().create_timer(0.5).timeout
		current_weapon = new_weapon
		can_shoot = true


func _input(event):
	if event.is_action_pressed("shoot") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("shoot") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and can_shoot:
		shoot()
		
	if event.is_action_pressed("magnum"):
		switch_weapon(weapons.PISTOL)
	if event.is_action_pressed("machine_gun"):
		switch_weapon(weapons.AUTO)
		
	if event.is_action_pressed("reload"):
		if current_weapon == weapons.PISTOL:
			pistol.reload()
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera.rotate_x(-deg_to_rad(event.relative.y * MouseSense))
		rotate_y(-deg_to_rad(event.relative.x * MouseSense))
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x,-70,80)
	
func deactivate_weapon():
	match current_weapon:
		weapons.PISTOL:
			pistol.deactivate()
		weapons.AUTO:
			auto.deactivate()
	
func _process(delta):
	weapon_camera.set_global_transform(camera.get_global_transform())
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
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
