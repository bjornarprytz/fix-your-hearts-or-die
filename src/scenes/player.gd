extends CharacterBody3D

@export var move_speed: float = 5.0
@export var rotation_speed: float = 0.01

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
		rotate_y(-event.relative.x * rotation_speed)

func _process(delta: float) -> void:
	var input_vector := Vector3.ZERO # Store movement input

	# Use standard "ui_" input actions
	if Input.is_action_pressed("ui_up"):
		input_vector.z -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.z += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1

	# Normalize to prevent faster diagonal movement
	input_vector = input_vector.normalized()

	# Apply movement
	# Account for rotation
	velocity = input_vector * move_speed
	move_and_slide()
