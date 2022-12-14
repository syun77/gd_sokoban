extends Area2D

var _dir = Direction.eType.DOWN

var _anim_timer = 0

onready var _spr = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	_anim_timer += delta
	
	_spr.frame = _get_anim_id(int(_anim_timer*4)%4)

func _get_anim_id(idx:int) -> int:
	var tbl = [0, 1, 0, 2]

	match _dir:
		_: #Direction.eType.DOWN:
			tbl = [0, 1, 0, 2]
			
	return tbl[idx]
