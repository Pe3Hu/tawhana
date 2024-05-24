extends Node


class Block:
	var mainland = null
	var grid = null
	var nexus = null
	var conqueror = null
	var neighbors = {}
	
	func _init(input_: Dictionary) -> void:
		mainland = input_.mainland
		grid = Vector2i(input_.grid)
	
		init_basic_setting()


	func init_basic_setting() -> void:
		mainland.grids.block[grid] = self


	func get_local_position() -> Vector2:
		return mainland.blocks.map_to_local(grid) - Vector2.ONE * Global.num.block.l / 2


	func get_global_position() -> Vector2:
		return mainland.to_global(mainland.blocks.map_to_local(grid))
		#return Vector2(grid) * Global.num.block.l


	func recolor_cell_based_on_god() -> void:
		var n = Global.num.mainland.gods / 3
		var x = conqueror.god.index % n
		var y = conqueror.god.index / n + 1
		var atlas_coord = Vector2i(x, y)
		mainland.blocks.set_cell(mainland.layer.floor, grid, mainland.source, atlas_coord)


class Conqueror:
	var god = null
	var mainland = null
	var blocks = []
	var nexuses = []
	var orbs = []
	
	func _init(input_: Dictionary) -> void:
		god = input_.god
	
		#init_basic_setting()


	func init_basic_setting() -> void:
		mainland = god.planet.mainland
		roll_nexus()


	func roll_nexus() -> void:
		var nexus = mainland.geysers.pick_random()
		mainland.geysers.erase(nexus)
		nexuses.append(nexus)
		
		for block in nexus.blocks:
			annex_block(block)
		
		var options = []
		
		for block in nexus.blocks:
			for neighbor in block.neighbors:
				if !blocks.has(neighbor) and !options.has(neighbor):
					options.append(neighbor)
					annex_block(neighbor)
		
		var block = options.pick_random()
		add_orb(block)


	func annex_block(block_: Block) -> void:
		block_.conqueror = self
		block_.recolor_cell_based_on_god()
		blocks.append(block_)


	func forfeit_block(block_: Block) -> void:
		block_.conqueror = null
		blocks.erase(block_)


	func add_orb(block_: Block) -> void:
		var input = {}
		input.conqueror = self
		input.block = block_#nexuses.pick_random().blocks.pick_random()
		
		var orb = Global.scene.orb.instantiate()
		mainland.planet.orbs.add_child(orb)
		orb.set_attributes(input)
		orbs.append(orb)
