extends StaticBody2D


#region var
var mainland = null
var grid = null
var blocks = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	mainland = input_.mainland
	grid = input_.grid
	
	init_basic_setting()


func init_basic_setting() -> void:
	mainland.grids.nexus[grid] = self
	init_blocks()
	
	position = blocks.front().get_local_position()
	position += Vector2.ONE * (Global.num.nexus.n + 0.5) * Global.num.block.l 


func init_blocks() -> void:
	for x in Global.num.nexus.n:
		for y in Global.num.nexus.n:
			var _grid = grid + Vector2i(x, y)
			var block = mainland.grids.block[_grid]
			blocks.append(block)
			block.nexus = self
	
#endregion
