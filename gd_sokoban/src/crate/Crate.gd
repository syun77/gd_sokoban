extends GridObject
# ===========================
# 荷物オブジェクト.
# ===========================
class_name Crate
# ---------------------------------------
# preload.
# ---------------------------------------

# ---------------------------------------
# const.
# ---------------------------------------


# ---------------------------------------
# enum.
# ---------------------------------------
enum eType {
	BROWN = Field.eTile.CRATE1,
	RED = Field.eTile.CRATE2,
	BLUE = Field.eTile.CRATE3,
	GREEN = Field.eTile.CRATE4,
}

# ---------------------------------------
# onready.
# ---------------------------------------
onready var _spr = $Sprite

# ---------------------------------------
# vars.
# ---------------------------------------
var _type = eType.BROWN
var _timer = 0.0

# ---------------------------------------
# public functions.
# ---------------------------------------
## 荷物の種類を取得する.
func get_type() -> int:
	return _type

## セットアップ.
func setup(i:int, j:int, type:int) -> void:
	_type = type
	_spr.frame = _get_anim_idx()
	set_pos(i, j, true)
	
# ---------------------------------------
# private functions.
# ---------------------------------------
func _process(delta: float) -> void:
	_timer = delta

## 種別に対応するスプライトフレーム番号を取得する
func _get_anim_idx() -> int:
	match _type:
		eType.BROWN:
			return 0
		eType.RED:
			return 1
		eType.BLUE:
			return 2
		_: # eType.GREEN:
			return 3
