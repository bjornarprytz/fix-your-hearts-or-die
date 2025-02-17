class_name Curtain
extends MeshInstance3D

signal on_clicked(curtain: Curtain)

@onready var clues_text: RichTextLabel = %Clues

var room: BlackLodgeMap.Room


func load_clues(future: BlackLodgeMap.Room, clues: BlackLodgeMap.FutureClues) -> void:
	room = future
	
	clues_text.clear()

	for item in clues.item_distance.keys():
		var distance = clues.item_distance[item]
		var text = "%s: %d\n" % [item.description, distance]
		
		if (distance == 0):
			text = "This is the %s room! Yay\n" % item.description
		
		clues_text.append_text(text)


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.is_pressed()):
		on_clicked.emit(self)
