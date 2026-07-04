extends CharacterBody3D


const SPEED = 5.0
const FLY_SPEED = 24.0
const JUMP_VELOCITY = 4.5
const SPRINT_MULTIPLIER = 2.0

@export var mouse_sensitivity: float = 0.01  # radians/pixel

@onready var head: Node3D = $Head
@onready var eye_camera: Camera3D = $Head/EyeCamera
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var flying: bool = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if flying:
			velocity = Vector3.ZERO
		else:
			velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("fly"):
		flying = !flying
		collision_shape_3d.disabled = flying
	
	var speed_multiplier: float = 1.0
	if Input.is_action_pressed("sprint"):
		speed_multiplier = SPRINT_MULTIPLIER

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("leftward", "rightward", "forward", "backward")
	var direction := (eye_camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() * speed_multiplier
	if direction:
		if flying:
			velocity = direction * FLY_SPEED
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if Input.is_action_pressed("jump") and flying:
		velocity.y = FLY_SPEED
	if Input.is_action_pressed("crouch") and flying:
		velocity.y = -FLY_SPEED

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var relative: Vector2 = event.relative * mouse_sensitivity
		head.rotate_y(-relative.x)
		eye_camera.rotate_x(-relative.y)
		eye_camera.rotation.x = clampf(eye_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
