extends CharacterBody3D

@onready var camera = $first_person_camera
@onready var weapon_camera = $PlayerInterface/SubViewportContainer/SubViewport/weapon_camera

@onready var weapon_rig = $PlayerInterface/SubViewportContainer/SubViewport/weapon_camera/Weapon_Rig
@onready var pistol = $PlayerInterface/SubViewportContainer/SubViewport/weapon_camera/Weapon_Rig/Pistol
@onready var gun_raycast = $first_person_camera/hit_trail
@onready var ammo_hud := $PlayerInterface/SubViewportContainer/SubViewport/HUD2/Ammo/HBoxContainer
@onready var health_hud := $PlayerInterface/SubViewportContainer/SubViewport/HUD2/Health
@onready var decal_scene = preload("res://subscenes/decal.tscn")
@onready var random_raycast = preload("res://subscenes/random_raycast.tscn")
@onready var red_screen = $PlayerInterface/SubViewportContainer/SubViewport/damaged
@onready var msg = $PlayerInterface/SubViewportContainer/SubViewport/HUD2/Message
#Auto's readies
@onready var auto = $PlayerInterface/SubViewportContainer/SubViewport/weapon_camera/Weapon_Rig/MachineGun
@onready var auto_pickup = $audio_files/auto_ammo_pickup
var CameraRotation = Vector2(0,0)
var MouseSense = 0.2001
var player_velocity = 0.0
const ACCELARATION = 0.7
const max_speed = 8.0
const JUMP_VELOCITY = 12.0
const default_target = Vector3(0,0,-50)

var health = 100
const max_health = 100

var can_shoot = true
var can_input = true

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
		
func die():
	if can_input:
		rotation.z = -PI/2
		velocity.y = JUMP_VELOCITY
		msg.announce("YOU DIED! PRESS SPACEBAR TO TRY AGAIN!",9999)
		can_input = false
		can_shoot = false
		weapon_rig.visible = false
		health_hud.visible = false
		ammo_hud.visible = false
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
			
func got_hit(damage:int):
	health = max(health-damage,0)
	red_screen.got_hit(damage/max_health)
	health_hud.update()
	if health <= 0 and can_input:
		die()
	pass

func _fire_auto():
	gun_raycast.target_position = Vector3(randf_range(-5,5),randf_range(-5,5),-50)
	if auto.fire():
		ammo_hud.give_shake()
		var target = gun_raycast.get_collider()
		var col_normal = gun_raycast.get_collision_normal()
		var col_point = gun_raycast.get_collision_point()
		if target != null:
			if gun_raycast.is_colliding() and target.get_collision_layer_value(2):
				target.got_hit(auto.damage)
			elif target != null:
				var b_decal = decal_scene.instantiate()
				target.add_child(b_decal)
				b_decal.global_position = col_point
				if col_normal == Vector3.DOWN:
					b_decal.rotation_degrees.x = 90
				elif col_normal != Vector3.UP:
					b_decal.look_at(col_point - col_normal, Vector3(0,1,0))
	gun_raycast.target_position = default_target
	pass

func _fire_pistol():
	#gun_raycast.target_position.z = -pistol.ray_range
	if pistol.shoot():
		ammo_hud.give_shake()
		var target = gun_raycast.get_collider()
		var col_normal = gun_raycast.get_collision_normal()
		var col_point = gun_raycast.get_collision_point()
		if gun_raycast.is_colliding() and target.get_collision_layer_value(2):
			target.got_hit(pistol.damage)
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
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera.rotate_x(-deg_to_rad(event.relative.y * MouseSense))
		rotate_y(-deg_to_rad(event.relative.x * MouseSense))
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x,-70,80)
	if not can_input:
		return
	if event.is_action_pressed("shoot") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("DEBUG_damage"):
		got_hit(10)
	if event.is_action_pressed("magnum"):
		switch_weapon(weapons.PISTOL)
	if event.is_action_pressed("machine_gun"):
		switch_weapon(weapons.AUTO)
		
	if event.is_action_pressed("reload"):
		if current_weapon == weapons.PISTOL:
			pistol.reload()	
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
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
		if can_input:
			velocity.y = JUMP_VELOCITY
		else:
			get_tree().change_scene_to_file("res://func_godot_test.tscn")

	# Get the input direction and handle the movement/deceleration.	
	# As good practice, you should replace UI actions with custom gameplay actions.
	if can_input:
		var input_dir = Input.get_vector("left", "right", "forward", "back")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			player_velocity += ACCELARATION
			player_velocity = clamp(player_velocity,0,max_speed)		
			velocity.x = direction.x * player_velocity
			velocity.z = direction.z * player_velocity
			if is_on_floor():
				weapon_rig.position.x += 0.005 * sin(time_stamp*10)
				weapon_rig.position.y += 0.0025 * sin(time_stamp*20)
			else:
				weapon_rig.position.y = lerpf(weapon_rig.position.y,-0.415,0.1)
				weapon_rig.position.x = lerpf(weapon_rig.position.x,-0.032,0.1)
		else:	
			player_velocity = lerpf(player_velocity,0,0.1)
			velocity.x = direction.x * player_velocity
			velocity.z = direction.z * player_velocity
			weapon_rig.position.y = lerpf(weapon_rig.position.y,-0.415,0.1)
			weapon_rig.position.x = lerpf(weapon_rig.position.x,-0.032,0.1)
	move_and_slide()


func _on_kill_zone_body_entered(body):
	if body.is_in_group("player"):
		got_hit(9999)
	pass # Replace with function body.
