extends Area2D
# ===========================
# プレイヤー.
# ===========================

class_name Player
# ---------------------------------------
# preload.
# ---------------------------------------
const Point2 = preload("res://src/common/Point2.gd")

# ---------------------------------------
# onready.
# ---------------------------------------
onready var _spr = $Sprite

# ---------------------------------------
# vars.
# ---------------------------------------
var _point := Point2.new()
var _dir = Direction.eType.DOWN
var _anim_timer = 0

# ---------------------------------------
# public functions.
# ---------------------------------------
func set_pos(p:Point2) -> void:
	_point = p
	position = Field.idx_to_world(_point, true)
	
# ---------------------------------------
# private functions.
# ---------------------------------------
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	_anim_timer += delta

	var is_moving = false
	if Input.is_action_just_pressed("ui_left"):
		_dir = Direction.eType.LEFT
		is_moving = true
	elif Input.is_action_just_pressed("ui_up"):
		_dir = Direction.eType.UP
		is_moving = true
	elif Input.is_action_just_pressed("ui_right"):
		_dir = Direction.eType.RIGHT
		is_moving = true
	elif Input.is_action_just_pressed("ui_down"):
		_dir = Direction.eType.DOWN		
		is_moving = true
	
	if is_moving:
		var next = Point2.new(_point.x, _point.y)
		next.iadd(Direction.get_point(_dir))
		if Field.can_move(next.x, next.y):
			# 移動可能.
			set_pos(next)
		
	_spr.frame = _get_anim_id(int(_anim_timer*4)%4)

func _get_anim_id(idx:int) -> int:
	var tbl = [0, 1, 0, 2]

	match _dir:
		Direction.eType.LEFT:
			tbl = [15, 17, 15, 16]
		Direction.eType.UP:
			tbl = [3, 5, 3, 4]
		Direction.eType.RIGHT:
			tbl = [12, 14, 12, 13]
		_: #Direction.eType.DOWN:
			tbl = [0, 1, 0, 2]
			
	return tbl[idx]
