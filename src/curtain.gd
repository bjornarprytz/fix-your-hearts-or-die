class_name Curtain
extends MeshInstance3D

signal on_clicked(curtain: Curtain)

@onready var ui: CurtainUI = %UI

var room: BlackLodgeMap.Room


func load_clues(future: BlackLodgeMap.Room, clues: BlackLodgeMap.FutureClues) -> void:
	room = future
	ui.show_clues(clues)
	
	


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.is_pressed()):
		on_clicked.emit(self)
