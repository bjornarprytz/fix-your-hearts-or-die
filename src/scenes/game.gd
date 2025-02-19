class_name Game
extends Node3D

@export var size: int = 20
@export var n_objectives: int = 2
@export var items: Array[BlackLodgeItem] = []

var collected_items: Array[BlackLodgeItem] = []

@export var red_room: RedRoom

var map: BlackLodgeMap

func _ready() -> void:
    map = BlackLodgeMap.generate(size, n_objectives, items)
    
    red_room.load_data(map.rooms.pick_random())

    Events.found_item.connect(_on_objective_found)

func _on_objective_found(item: BlackLodgeItem) -> void:

    if (item in collected_items):
        return

    collected_items.append(item)

    if (collected_items.size() == n_objectives):
        Events.game_over.emit(true)
        print("You win!?")
        return
