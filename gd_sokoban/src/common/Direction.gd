extends Node

enum eType {
	LEFT,
	UP,
	RIGHT,
	DOWN,
}

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
