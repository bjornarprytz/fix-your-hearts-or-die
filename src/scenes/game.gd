extends Node3D

@export var size: int = 20
@export var n_objectives: int = 2
@export var items: Array[BlackLodgeItem] = []


@export var red_room : RedRoom


var map: BlackLodgeMap

func _ready() -> void:
	map = BlackLodgeMap.generate(size, n_objectives, items)
	
	red_room.load_data(map.rooms.pick_random())
