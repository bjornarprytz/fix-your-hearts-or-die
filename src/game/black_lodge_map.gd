class_name BlackLodgeMap
extends Node


var rooms: Array[Room]
var red_herrings: Array[BlackLodgeItem]
var objectives: Array[BlackLodgeItem]

class Room:
    var number: int
    var item: BlackLodgeItem = null
    var clues: Dictionary[BlackLodgeItem, int] = {}
    var futures: Array[Room] = []

    func _init(room_number: int, objectives: Array[BlackLodgeItem], _red_herrings: Array[BlackLodgeItem]) -> void:
        number = room_number

        for objective in objectives:
            clues[objective] = -1
        
        for red_herring in _red_herrings:
            clues[red_herring] = (randi() % 9) + 1
    
    func add_future(room: Room) -> bool:
        if (room == self):
            # Cannot add self as future
            return false

        if (futures.size() >= 4):
            # Room already has the max 4 futures
            return false
        
        if (room in futures):
            # Room already has this future
            return false

        futures.append(room)
        return true

static func generate(size: int, n_objectives: int, items: Array[BlackLodgeItem]) -> BlackLodgeMap:
    var map := BlackLodgeMap.new()
    map.red_herrings = []
    map.objectives = []
    
    # Shuffle items
    items.shuffle()
    
    # Assign objectives
    for i in range(n_objectives):
        map.objectives.append(items.pop_front())
    
    map.red_herrings = items # The rest of the items are red herrings

    # Generate rooms
    map.rooms = []
    for i in range(size):
        var room := Room.new(i, map.objectives, map.red_herrings)
        map.rooms.append(room)
    
    # Generate futures
    for room in map.rooms:
        for _i in range(4):
            while (true):
                var future := map.rooms[randi() % size]
                if room.add_future(future):
                    break
    
    # Check that every room is reachable

    for starting_room in map.rooms:
        var visited: Array[Room] = []
        var stack: Array[Room] = [starting_room]
        while (stack.size() > 0):
            var room = stack.pop_back()
            visited.append(room)
            for future in room.futures:
                if !(future in visited) and !(future in stack):
                    stack.push_back(future)

        if (visited.size() != size):
            # Not all rooms are reachable
            print("Not all rooms are reachable from room %d" % starting_room.number)
            return generate(size, n_objectives, items)
    
    print("Map generated successfully")

    return map