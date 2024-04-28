extends CharacterBody3D

@onready var camera = $first_person_camera
@onready var weapon_camera = $PlayerInterface/SubViewportContainer/SubViewport/weapon_camera

@onready var weapon_rig = $PlayerInterface/SubViewportContainer/SubViewport/weapon_camera/Weapon_Rig
@onready var pistol = $PlayerInterface/SubViewportContainer/SubViewport/weapon_camera/Weapon_Rig/Pistol
@onready var gun_raycast = $first_person_camera/hit_trail
@onready var ammo_hud := $PlayerInterface/SubViewportContainer/SubViewport/HUD2/Ammo/HBoxContainer

@onready var decal_scene = preload("res://subscenes/decal.tscn")
#Auto's readies
@onready var auto = $PlayerInterface/SubViewportContainer/SubViewport/weapon_camera/Weapon_Rig/MachineGun
@onready var auto_pickup = $audio_files/auto_ammo_pickup
var CameraRotation = Vector2(0,0)
var MouseSense = 0.2001
const SPEED = 10.0
const JUMP_VELOCITY = 12.0

var can_shoot = true

enum weapons {
	PISTOL,
	AUTO
}

var weapon_stack = [weapons.PISTOL]

var current_weapon = weapons.PISTOL

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func grant_weapon(name:String) -> bool:
	if name == "auto" and weapons.AUTO not in weapon_stack:
		weapon_stack.append(weapons.AUTO)
		switch_weapon(weapons.AUTO)
		grant_ammo("auto_ammo",100)
		return true
	else:
		return grant_ammo("auto_ammo",100)
		

func grant_ammo(name:String,amount:int) -> bool:
	match name:
		"auto_ammo":
			if(auto.current_ammo != auto.max_ammo):
				auto.current_ammo = min(auto.current_ammo + amount,auto.max_ammo)
				return true
			else:
				return false
		_:
			print("Collectible not implemented!")
			return false

func _fire_auto():
	#gun_raycast.target_position.z *= auto.ray_range
	if auto.fire():
		ammo_hud.give_shake()
		var target = gun_raycast.get_collider()
		var col_normal = gun_raycast.get_collision_normal()
		var col_point = gun_raycast.get_collision_point()
		if gun_raycast.is_colliding() and target.get_collision_layer_value(2):
			target.got_hit()
		elif target != null:
			var b_decal = decal_scene.instantiate()
			target.add_child(b_decal)
			b_decal.global_position = col_point
			if col_normal == Vector3.DOWN:
				b_decal.rotation_degrees.x = 90
			elif col_normal != Vector3.UP:
				b_decal.look_at(col_point - col_normal, Vector3(0,1,0))
	#gun_raycast.target_position.z /- auto.ray_range
	pass

func _fire_pistol():
	#gun_raycast.target_position.z = -pistol.ray_range
	if pistol.shoot():
		ammo_hud.give_shake()
		var target = gun_raycast.get_collider()
		var col_normal = gun_raycast.get_collision_normal()
		var col_point = gun_raycast.get_collision_point()
		if gun_raycast.is_colliding() and target.get_collision_layer_value(2):
			target.got_hit()
		elif target != null:
			var b_decal = decal_scene.instantiate()
			target.add_child(b_decal)
			b_decal.global_position = col_point
			if col_normal == Vector3.DOWN:
				b_decal.rotation_degrees.x = 90
			elif col_normal != Vector3.UP:
				b_decal.look_at(col_point - col_normal, Vector3(0,1,0))
	#gun_raycast.target_position.z = -1
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
	if new_weapon != current_weapon and new_weapon in weapon_stack:
		can_shoot = false
		deactivate_weapon()
		activate_weapon(new_weapon)
		await get_tree().create_timer(0.5).timeout
		current_weapon = new_weapon
		can_shoot = true
func play_sound():
	auto_pickup.play()
	pass

func _input(event):
	if event.is_action_pressed("shoot") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
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
var time_stamp = 0
func _process(delta):
	if Input.is_action_pressed("shoot") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and can_shoot:
		shoot()
	weapon_camera.set_global_transform(camera.get_global_transform())
func _physics_process(delta):
	time_stamp += delta
	if time_stamp > 10000:
		time_stamp = 0
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
		if is_on_floor():
			weapon_rig.position.x += 0.005 * sin(time_stamp*10)
			weapon_rig.position.y += 0.0025 * sin(time_stamp*20)
		else:
			weapon_rig.position.y = lerpf(weapon_rig.position.y,-0.415,0.1)
			weapon_rig.position.x = lerpf(weapon_rig.position.x,-0.032,0.1)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		weapon_rig.position.y = lerpf(weapon_rig.position.y,-0.415,0.1)
		weapon_rig.position.x = lerpf(weapon_rig.position.x,-0.032,0.1)
		
	move_and_slide()
