extends CharacterBody3D

@export var move_speed: float = 4.0  
@export var rotation_duration: float = 0.6  
@export var move_duration: float = 0.4  

var is_moving: bool = false  # on button push at a time

func _input(event: InputEvent) -> void:
	if is_moving:
		return  # Ignore input while in action

	if event.is_action_pressed("ui_left"):
		rotate_character(90)  
	elif event.is_action_pressed("ui_right"):
		rotate_character(-90) 

func rotate_character(degrees: float) -> void:
	is_moving = true  # pause other movement inputs

	# rotate
	var target_rotation = transform.basis.rotated(Vector3.UP, deg_to_rad(degrees))

	var tween = create_tween()
	tween.tween_property(self, "transform:basis", target_rotation, rotation_duration).set_trans(Tween.TRANS_LINEAR)
	await tween.finished

	is_moving = false  # Allow another rotation
	

func _process(delta: float) -> void:
	
	var input_vector := get_global_transform().basis.x # Store movement input
	input_vector = input_vector.normalized()
	velocity = input_vector * move_speed
	if Input.is_action_pressed("ui_up") && is_moving != true:
		move_and_slide()
