/****************************
stencil.gdshader
****************************/

shader_type canvas_item;

uniform sampler2D stencil_tex;
uniform vec4 target_color : source_color = vec4(1.0, 0.0, 1.0, 1.0);
uniform float tolerance : hint_range(0.0, 1.0);
uniform bool invert_mask = false;

void fragment() {
	vec4 tex_color = texture(stencil_tex, UV);
	float diff = distance(tex_color.rgb, target_color.rgb);

	if (diff <= tolerance) {
		COLOR.a = invert_mask ? 0.0 : 1.0;
	} else {
		COLOR.a = invert_mask ? 1.0 : 0.0;
	}
}

/****************************
stencil.gd
****************************/

@tool
extends Node3D

@export var target_camera: Camera3D = null
@export var mask_camera : Camera3D = null
@export var mask_viewport : SubViewport

var shader_material: ShaderMaterial = null

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		var editor_viewport = EditorInterface.get_editor_viewport_3d(0)
		var editor_camera = editor_viewport.get_camera_3d();

		mask_camera.global_transform = editor_camera.global_transform
		mask_camera.fov = editor_camera.fov
		mask_viewport.size = editor_viewport.size

	elif target_camera != null:
		mask_camera.global_transform = target_camera.global_transform
		mask_camera.fov = target_camera.fov
		mask_viewport.size = get_viewport().size
