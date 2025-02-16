extends CharacterBody3D

@export var move_amount: float = 2.0
@export var move_speed: float = 1.0  
@export var rotation_duration: float = 0.6  
@export var move_duration: float = 0.4  
@export var button_delay: float = 0.2


var is_moving: bool = false  # on button push at a time

func _input(event: InputEvent) -> void:
	if is_moving:
		return  # Ignore input while in action

	if event.is_action_pressed("ui_left"):
		rotate_character(90)  
	elif event.is_action_pressed("ui_right"):
		rotate_character(-90) 
	elif event.is_action_pressed("ui_up"):
		move_forward()

func rotate_character(degrees: float) -> void:
	is_moving = true  # pause other movement inputs

	# rotate
	var target_rotation = transform.basis.rotated(Vector3.UP, deg_to_rad(degrees))

	var tween = create_tween()
	tween.tween_property(self, "transform:basis", target_rotation, rotation_duration).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	await get_tree().create_timer(button_delay).timeout
	is_moving = false
	

#func _process(delta: float) -> void:
	#
	#var input_vector := get_global_transform().basis.x # Store movement input
	#input_vector = input_vector.normalized()
	#velocity = input_vector * move_speed
	#if Input.is_action_pressed("ui_up") && is_moving != true:
		#move_and_slide()
		
func move_forward():
	is_moving = true
	var input_vector := get_global_transform().basis.y * -1 # Store movement input
	input_vector = input_vector.normalized()
	var tween = create_tween()
	tween.tween_property(self, "position", position + input_vector * move_amount, move_speed)
	await tween.finished
	await get_tree().create_timer(button_delay).timeout
	is_moving = false
