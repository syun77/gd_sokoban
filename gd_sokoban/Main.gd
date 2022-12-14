extends Node2D

const FIELD_OFS_X = 0
const FIELD_OFS_Y = 0
const TILE_SIZE = 64.0

func idx_to_world_x(i:int) -> float:
	return FIELD_OFS_X + (i * TILE_SIZE)
func idx_to_world_y(j:int) -> float:
	return FIELD_OFS_Y + (j * TILE_SIZE)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _draw() -> void:
	for j in range(8):
		var py = j * TILE_SIZE
		for i in range(12):
			var px = i * TILE_SIZE
			var pos = Vector2(px, py)
			var size = Vector2(TILE_SIZE, TILE_SIZE)
			var rect = Rect2(pos, size)
			draw_rect(rect, Color.silver, false)
