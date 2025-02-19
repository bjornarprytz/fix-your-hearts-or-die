class_name RedRoom
extends Area3D

@onready var curtain_1: Curtain = %Curtain1
@onready var curtain_2: Curtain = %Curtain2
@onready var curtain_3: Curtain = %Curtain3
@onready var curtain_4: Curtain = %Curtain4

@onready var curtains: Array[Curtain] = [curtain_1, curtain_2, curtain_3, curtain_4]

var _room_data: BlackLodgeMap.Room

func _ready() -> void:
	for i in range(curtains.size()):
		var curtain = curtains[i]
		curtain.on_clicked.connect(on_curtain_clicked)

func load_data(room_data: BlackLodgeMap.Room) -> void:
	_room_data = room_data
	
	if (room_data.item != null):
		Events.found_item.emit(room_data.item)
	
	
	for i in range(room_data.futures.size()):
		var future = room_data.futures[i]
		var curtain = curtains[i]
		
		curtain.load_clues(future, room_data.clues[future])


func on_curtain_clicked(curtain: Curtain):
	load_data(curtain.room)
