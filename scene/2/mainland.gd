extends Node2D


#region var
@onready var blocks = $Blocks
@onready var nexuses = $Nexuses

var planet = null
var grids = {}
var layer = {}
var source = null
var geysers = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	
	init_basic_setting()


func init_basic_setting() -> void:
	layer.floor = 0
	source = 0
	
	init_blocks()
	init_nexuses()
	init_geysers()


func init_blocks() -> void:
	grids.block = {}
	var l = Global.num.block.l
	planet.custom_minimum_size = Vector2.ONE * Global.num.mainland.n * l
	planet.orbs.position += Vector2.ONE * l / 2
	nexuses.position -= Vector2.ONE * (Global.num.nexus.n / 2 + 0.5) * l
	
	for y in Global.num.mainland.n + 2:
		for x in Global.num.mainland.n + 2:
			var grid = Vector2i(x, y)
			add_block(grid)
	
	update_block_neighbors()


func add_block(grid_: Vector2i) -> void:
	var input = {}
	input.mainland = self
	input.grid = grid_
	input.type = "floor"
	
	var atlas_coord = Vector2i(1, 0)
	var corners = [0, Global.num.mainland.n + 1]
	
	if corners.has(grid_.x) or corners.has(grid_.y):
		atlas_coord = Vector2i(0, 0)
		input.type = "wall"
	
	blocks.set_cell(layer.floor, grid_, source, atlas_coord)
	var _block = Classes.Block.new(input)



func update_block_neighbors() -> void:
	for grid in grids.block:
		var block = grids.block[grid]
		
		for direction in Global.dict.direction.linear:
			var _grid = direction + grid
			
			if grids.block.has(_grid):
				var neighbor = grids.block[_grid]
				
				if !block.neighbors.has(neighbor):
					block.neighbors[neighbor] = direction
					neighbor.neighbors[block] = -direction


func init_nexuses() -> void:
	grids.nexus = {}
	
	for y in range(1, Global.num.mainland.n + 1, Global.num.nexus.n):
		for x in range(1, Global.num.mainland.n + 1, Global.num.nexus.n):
			var grid = Vector2i(x, y)
			add_nexus(grid)


func add_nexus(grid_: Vector2i) -> void:
	var input = {}
	input.mainland = self
	input.grid = grid_
	
	var nexus = Global.scene.nexus.instantiate()
	nexuses.add_child(nexus)
	nexus.set_attributes(input)


func init_geysers() -> void:
	var corners = [0, Global.num.mainland.n + 2]
	var offset = Global.num.nexus.border * Global.num.nexus.n + 1
	corners[0] += offset
	corners[1] -= offset
	
	var step = (Global.num.nexus.gap + 1) * Global.num.nexus.n
	
	for y in range(corners.front(), corners.back(), step):
		for x in range(corners.front(), corners.back(), step):
			var grid = Vector2i(x, y) 
			var nexus = grids.nexus[grid]
			geysers.append(nexus)


func grid_radius_check(grid_: Vector2i) -> bool:
	return abs(grid_.x) <= Global.num.mainland.rings and abs(grid_.y) <= Global.num.mainland.rings
#endregion
