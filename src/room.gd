class_name RedRoom
extends Area3D

@onready var floor: MeshInstance3D = %Floor
@onready var wall_1: Curtain = %Wall1
@onready var wall_2: Curtain = %Wall2
@onready var wall_3: Curtain = %Wall3
@onready var wall_4: Curtain = %Wall4

@onready var curtains: Array[Curtain] = [wall_1, wall_2, wall_3, wall_4]

var _room_data: BlackLodgeMap.Room

func _ready() -> void:
	for i in range(curtains.size()):
		var wall = curtains[i]
		wall.on_clicked.connect(on_curtain_clicked)

func load_data(room_data: BlackLodgeMap.Room) -> void:
	_room_data = room_data
	floor.mesh.surface_set_material(0, floor.material_override)
	
	for i in range(room_data.futures.size()):
		var future = room_data.futures[i]
		var wall = curtains[i]
		
		wall.load_clues(future, room_data.clues[future])


func on_curtain_clicked(curtain: Curtain):
	load_data(curtain.room)
