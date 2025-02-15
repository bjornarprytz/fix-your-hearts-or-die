shader_type spatial;

//textures n roughness n shit
uniform sampler2D albedo_texture;
uniform float roughness : hint_range(0.0, 1.0) = 0.1;
uniform float metallic : hint_range(0.0, 1.0) = 0.2;

//mesh deformation properties
uniform float wave_strength : hint_range(0.0, 0.5) = 0.1;
uniform float wave_speed : hint_range(0.1, 5.0) = 2.0;
uniform float rotation_strength : hint_range(0.0, 0.2) = 0.1;

void vertex() {
    float time_factor = TIME * wave_speed;

//jitter with sine
    vec3 wave_offset = vec3(
        sin(VERTEX.x * 2.0 + time_factor) * wave_strength,
        sin(VERTEX.y * 3.0 + time_factor) * wave_strength,
        sin(VERTEX.z * 1.5 + time_factor) * wave_strength
    );

//rot deformation
    float rot_noise = sin(VERTEX.x * 1.2 + VERTEX.y * 1.5 + time_factor) * rotation_strength;

    mat3 rot_matrix = mat3(
        vec3(cos(rot_noise), -sin(rot_noise), 0.0),
        vec3(sin(rot_noise), cos(rot_noise), 0.0),
        vec3(0.0, 0.0, 1.0)
    );

    VERTEX += wave_offset;
    VERTEX = rot_matrix * VERTEX;
}

void fragment() {
    vec4 albedo_color = texture(albedo_texture, UV);
    ALBEDO = albedo_color.rgb;

    ROUGHNESS = roughness;
    METALLIC = metallic;
}
