class_name CurtainUI
extends Control

@onready var _clues: GridContainer = %Clues
@onready var this_is_the_room: RichTextLabel = %ThisIsTheRoom

func show_clues(clues: BlackLodgeMap.FutureClues) -> void:
	var clue_icons : Array[TextureRect] = []
	
	this_is_the_room.clear()
	for child in _clues.get_children():
		child.queue_free()
	
	for item in clues.item_distance.keys():
		var distance = clues.item_distance[item]	
		
		if (distance > 0):
			for i in range(distance):
				var tex = TextureRect.new()
				tex.texture = item.icon
				
				clue_icons.push_back(tex)
		else:
			this_is_the_room.add_text("You are in the %s room now!" % item.description)
	#clue_icons.shuffle()
	
	for icon in clue_icons:
		_clues.add_child(icon)
