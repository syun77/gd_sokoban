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
@onready var _spr = $Sprite
@onready var _spr2 = $Sprite2

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

## 更新
func proc(_delta: float) -> void:
	pass

# ---------------------------------------
# private functions.
# ---------------------------------------
func _ready() -> void:
	_spr2.visible = false

## アニメーションの更新.
func _process(delta: float) -> void:
	_timer += delta
	
	_spr2.visible = false
	if Field.is_match_crate_type(idx_x(), idx_y(), _type):
		# マッチしているので点滅する.
		_spr2.visible = true
		_spr2.modulate.a = 0.5 * abs(sin(_timer*4))

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
