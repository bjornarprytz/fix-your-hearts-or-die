class_name BlackLodgeMap
extends Node

var rooms: Array[Room]
var red_herrings: Array[BlackLodgeItem]
var objectives: Array[BlackLodgeItem]

class FutureClues:
	var item_distance: Dictionary[BlackLodgeItem, int] = {}

	func _init(objectives: Array[BlackLodgeItem], _red_herrings: Array[BlackLodgeItem]) -> void:
		for objective in objectives:
			item_distance[objective] = -1 # Uninitialized
		
		for red_herring in _red_herrings:
			item_distance[red_herring] = (randi() % 9) + 1


class Room:
	var number: int
	var item: BlackLodgeItem = null
	var clues: Dictionary[Room, FutureClues] = {}
	var futures: Array[Room] = []

	var _objectives = []
	var _red_herrings = []

	func _init(room_number: int, __objectives: Array[BlackLodgeItem], __red_herrings: Array[BlackLodgeItem]) -> void:
		number = room_number

		_objectives = __objectives
		_red_herrings = __red_herrings
	
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
		clues[room] = FutureClues.new(_objectives, _red_herrings)
		return true

static func generate(size: int, n_objectives: int, items: Array[BlackLodgeItem]) -> BlackLodgeMap:
	if (size < n_objectives):
		push_error("Not enough rooms for objectives")
		return generate(size, n_objectives, items)
	
	if (items.size() < n_objectives):
		push_error("Not enough items for objectives")
		return generate(size, n_objectives, items)

	var map := BlackLodgeMap.new()
	map.red_herrings = []
	map.objectives = []
	
	# Shuffle items
	map.red_herrings = items.duplicate()
	map.red_herrings.shuffle()
	
	# Assign objectives
	for i in range(n_objectives):
		var item = map.red_herrings.pop_front() # This might look weird, but it works
		map.objectives.append(item)

	# Generate rooms
	map.rooms = []
	for i in range(size):
		var room := Room.new(i, map.objectives, map.red_herrings)
		map.rooms.append(room)
	
	var indices = range(size)
	indices.shuffle()
	for objective in map.objectives:
		var room = map.rooms[indices.pop_front()]
		if (room.item != null):
			push_error("It should not be possible to find a room with an item already")

		room.item = objective
	
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
		var queue: Array[Room] = [starting_room]
		while (queue.size() > 0):
			var room = queue.pop_front()
			
			visited.append(room)
			for future in room.futures:
				if !(future in visited) and !(future in queue):
					queue.push_back(future)

		if (visited.size() != size):
			# Not all rooms are reachable
			print("Not all rooms are reachable from room %d. Trying again..." % starting_room.number)
			return generate(size, n_objectives, items)
		
		# Find shortest path to objectives from each future
		for future in starting_room.futures:
			visited = []
			queue = [future]
			var next_queue: Array[Room] = []
			if starting_room.item != null:
				starting_room.clues[future].item_distance[starting_room.item] = 0

			var distance = 1
			while (queue.size() > 0):
				var room = queue.pop_front()
				
				visited.append(room)
				if (room.item != null && starting_room.clues[future].item_distance[room.item] == -1):
					starting_room.clues[future].item_distance[room.item] = distance
				for next_future in room.futures:
					if !(next_future in visited) and !(next_future in queue) and !(next_future in next_queue):
						next_queue.push_back(next_future)
				
				if (queue.size() == 0):
					distance += 1
					queue = next_queue
					next_queue = []

	print("Map generated successfully")

	return map
