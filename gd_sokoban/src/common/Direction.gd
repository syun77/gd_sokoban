extends Node
# ===========================
# 方向を扱う.
# ===========================

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
enum eType {
	NONE,
	
	LEFT,
	UP,
	RIGHT,
	DOWN,
}
# ---------------------------------------
# public functions.
# ---------------------------------------
func get_vector(type:int) -> Vector2:
	match type:
		eType.LEFT:
			return Vector2(-1, 0)
		eType.UP:
			return Vector2(0, -1)
		eType.RIGHT:
			return Vector2(1, 0)
		_:
			return Vector2(0, 1)

func get_point(type:int) -> Point2:
	match type:
		eType.LEFT:
			return Point2.new(-1, 0)
		eType.UP:
			return Point2.new(0, -1)
		eType.RIGHT:
			return Point2.new(1, 0)
		_:
			return Point2.new(0, 1)

func to_name(type:int) -> String:
	match type:
		eType.LEFT:
			return "LEFT"
		eType.UP:
			return "UP"
		eType.RIGHT:
			return "RIGHT"
		eType.DOWN:
			return "DOWN"
		_:
			return "NONE"
# ---------------------------------------
# private functions.
# ---------------------------------------
