extends Node2D
# ===========================
# メイン.
# ===========================

# ---------------------------------------
# preload.
# ---------------------------------------
const Point2 = preload("res://src/common/Point2.gd")
const PlayerObj = preload("res://src/player/Player.tscn")
const CrateObj = preload("res://src/crate/Crate.tscn")

# ---------------------------------------
# onready.
# ---------------------------------------
onready var _tile_back = $TileMapBack
onready var _tile_front = $TileMapFront
onready var _player:Player = null
# キャンバスレイヤー.
onready var _crate_layer = $CrateLayer

# ---------------------------------------
# vars.
# ---------------------------------------
var _timer = 0.0

# ---------------------------------------
# private functions.
# ---------------------------------------
func _ready() -> void:
	
	# 共通モジュールをセットアップする.
	var layers = {
		"crate": _crate_layer,
	}
	Common.setup(layers)
	
	# フィールドをセットアップする.
	Field.setup(_tile_front)

	# Frontタイルの情報からインスタンスを生成する.	
	for j in range(Field.TILE_HEIGHT):
		for i in range(Field.TILE_WIDTH):
			var v = _tile_front.get_cell(i, j)
			if _create_obj(i, j, v):
				# 生成したらタイルの情報は消しておく.
				_tile_front.set_cell(i, j, Field.eTile.NONE)
	
	# スタート地点が未設定の場合はランダムな位置にプレイヤーを出現させる.
	if _player == null:
		var p = Field.search_random_none()
		_create_player(p.x, p.y)

## タイル情報から生成されるオブジェクトをチェック＆生成.
func _create_obj(i:int, j:int, id:int) -> bool:
	match id:
		Field.eTile.START: # プレイヤー開始位置.
			_create_player(i, j)
			return true
		Field.eTile.CRATE1, Field.eTile.CRATE2, Field.eTile.CRATE3, Field.eTile.CRATE4:
			# 荷物.
			_create_crate(i, j, id)
			return true
	
	return false

## プレイヤーの生成.
func _create_player(i:int, j:int) -> void:
	_player = PlayerObj.instance()
	var p = Point2.new(i, j)
	_player.set_pos(p.x, p.y, true)
	add_child(_player)

## 荷物の生成.
func _create_crate(i:int, j:int, id:int) -> void:
	var crate = CrateObj.instance()
	# Spriteの更新があるので先に add_child() する.
	_crate_layer.add_child(crate)
	crate.setup(i, j, id)

## 更新.
func _process(delta:float) -> void:
	_timer += delta
	
	if Input.is_action_just_pressed("ui_reset"):
		get_tree().change_scene("res://Main.tscn")
