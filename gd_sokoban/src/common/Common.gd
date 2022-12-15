extends Node

const Point2 = preload("res://src/common/Point2.gd")

const TILE_SIZE = 64.0

const FIELD_OFS_X = 0
const FIELD_OFS_Y = 0
const TILE_WIDTH = 12
const TILE_HEIGHT = 8

enum eTile {
	NONE = -1,
	# 通路
	BLANK = 0,
	# 壁
	BLOCK = 1,
	# 荷物
	CRATE1 = 2,
	CRATE2 = 3,
	CRATE3 = 4,
	CRATE4 = 5,
	# 荷物を移動させる場所.
	POINT1 = 6,
	POINT2 = 7,
	POINT3 = 8,
	POINT4 = 9,
	# プレイヤー
	START = 10, # 開始地点
}

func idx_to_world_x(i:int, is_center:bool=false) -> float:
	var i2 = i
	if is_center:
		i2 += 0.5	
	return FIELD_OFS_X + (i2 * TILE_SIZE)
func idx_to_world_y(j:int, is_center:bool=false) -> float:
	var j2 = j
	if is_center:
		j2 += 0.5	
	return FIELD_OFS_Y + (j2 * TILE_SIZE)
func idx_to_world(p:Point2, is_center:bool=false) -> Vector2:
	var v = Vector2()
	v.x = idx_to_world_x(p.x, is_center)
	v.y = idx_to_world_y(p.y, is_center)
	return v
