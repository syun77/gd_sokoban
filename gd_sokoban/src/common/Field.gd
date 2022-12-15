extends Node
# ===========================
# フィールド関連.
# ===========================

# ---------------------------------------
# preload.
# ---------------------------------------
const Point2 = preload("res://src/common/Point2.gd")

# ---------------------------------------
# const.
# ---------------------------------------
const TILE_SIZE = 64.0

const FIELD_OFS_X = 0
const FIELD_OFS_Y = 0
const TILE_WIDTH = 12
const TILE_HEIGHT = 8

# ---------------------------------------
# enum.
# ---------------------------------------
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

# ---------------------------------------
# vars.
# ---------------------------------------
var _tile:TileMap = null

# ---------------------------------------
# public functions.
# ---------------------------------------
## セットアップ.
func setup(tile:TileMap) -> void:
	_tile = tile

func get_cell(i:int, j:int) -> int:
	return _tile.get_cell(i, j)

## 移動可能な位置かどうか.
func can_move(i:int, j:int) -> bool:
	match get_cell(i, j):
		eTile.BLOCK:
			return false
		_:
			return true

## インデックスX座標をワールドX座標に変換する.
func idx_to_world_x(i:int, is_center:bool=false) -> float:
	var i2 = i
	if is_center:
		i2 += 0.5	
	return FIELD_OFS_X + (i2 * TILE_SIZE)
## インデックスY座標をワールドY座標に変換する.
func idx_to_world_y(j:int, is_center:bool=false) -> float:
	var j2 = j
	if is_center:
		j2 += 0.5	
	return FIELD_OFS_Y + (j2 * TILE_SIZE)
## インデックス座標系をワールド座標系に変換する.
func idx_to_world(p:Point2, is_center:bool=false) -> Vector2:
	var v = Vector2()
	v.x = idx_to_world_x(p.x, is_center)
	v.y = idx_to_world_y(p.y, is_center)
	return v

## 何もない場所をランダムで返す.
func search_random_none() -> Point2:
	var arr = []
	for j in range(TILE_HEIGHT):
		for i in range(TILE_WIDTH):
			if _tile.get_cell(i, j) == eTile.NONE:
				arr.append(Point2.new(i, j))
	
	arr.shuffle()
	return arr[0]

# ---------------------------------------
# private functions.
# ---------------------------------------
