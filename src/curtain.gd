class_name Curtain
extends MeshInstance3D

signal on_clicked(curtain: Curtain)
signal on_hovered(curtain: Curtain, hovered: bool)

@onready var ui: CurtainUI = %UI

var room: BlackLodgeMap.Room


func load_clues(future: BlackLodgeMap.Room, clues: BlackLodgeMap.FutureClues) -> void:
	room = future
	ui.show_clues(clues)
	

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.is_pressed()):
		on_clicked.emit(self)
	

func _on_area_3d_mouse_entered() -> void:
	on_hovered.emit(self, true)

func _on_area_3d_mouse_exited() -> void:
	on_hovered.emit(self, false)
