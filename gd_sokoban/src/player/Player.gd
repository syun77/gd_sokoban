extends Area2D

var _dir = Direction.eType.DOWN

var _anim_timer = 0

onready var _spr = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	_anim_timer += delta

	var is_moving = false
	if Input.is_action_pressed("ui_left"):
		_dir = Direction.eType.LEFT
		is_moving = true
	elif Input.is_action_pressed("ui_up"):
		_dir = Direction.eType.UP
		is_moving = true
	elif Input.is_action_pressed("ui_right"):
		_dir = Direction.eType.RIGHT
		is_moving = true
	elif Input.is_action_pressed("ui_down"):
		_dir = Direction.eType.DOWN		
		is_moving = true
	
	if is_moving:
		position += 100 * Direction.get_vector(_dir) * delta
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
