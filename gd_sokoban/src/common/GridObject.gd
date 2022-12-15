extends Node2D

# ===========================
# グリッド(インデックス)座標系で動作するオブジェクトの既定.
# ===========================
class_name GridObject

# ---------------------------------------
# preload.
# ---------------------------------------
const Point2 = preload("res://src/common/Point2.gd")

# ---------------------------------------
# const.
# ---------------------------------------


# ---------------------------------------
# enum.
# ---------------------------------------

# ---------------------------------------
# onready.
# ---------------------------------------

# ---------------------------------------
# vars.
# ---------------------------------------
var _point = Point2.new()
var _dir:int = Direction.eType.DOWN

# ---------------------------------------
# public functions.
# ---------------------------------------
## インデックス座標系を設定.	
func set_pos(i:int, j:int, is_center:bool) -> void:
	position.x = Field.idx_to_world_x(i, is_center)
	position.y = Field.idx_to_world_y(j, is_center)
	_point.set_xy(i, j)
func set_dir(dir:int) -> void:
	_dir = dir
	
func is_same_pos(i:int, j:int) -> bool:
	return _point.equal_xy(i, j)

func idx_x() -> int:
	return _point.x
func idx_y() -> int:
	return _point.y

# ---------------------------------------
# private functions.
# ---------------------------------------
