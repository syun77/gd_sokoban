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
# const.
# ---------------------------------------
const _DEBUG_UNDO_LOG = false # undoのログを表示するかどうか.

enum eState {
	MAIN, # メイン.
	STAGE_CLEAR, # ステージクリア.
}

# ---------------------------------------
# onready.
# ---------------------------------------
onready var _player:Player = null
onready var _ui_caption = $UILayer/LabelCaption
onready var _ui_step = $UILayer/LabelStep
onready var _ui_reset = $UILayer/ResetButton
onready var _ui_undo = $UILayer/UndoButton
onready var _ui_redo = $UILayer/RedoButton
# キャンバスレイヤー.
onready var _tile_layer = $TileLayer
onready var _obj_layer = $ObjLayer
onready var _crate_layer = $CrateLayer

# ---------------------------------------
# vars.
# ---------------------------------------
var _timer = 0.0
var _state = eState.MAIN

# ---------------------------------------
# private functions.
# ---------------------------------------
func _ready() -> void:
	_ui_caption.visible = false
	_ui_step.visible = false
	_ui_undo.visible = false
	_ui_redo.visible = false
	
	var level_path = Common.get_level_scene()
	var level_res = load(level_path)
	var level_obj = level_res.instance()
	_tile_layer.add_child(level_obj)
	var tile_front = level_obj.get_node("./Front")
	
	# フィールドをセットアップする.
	Field.setup(tile_front)

	# Frontタイルの情報からインスタンスを生成する.	
	for j in range(Field.TILE_HEIGHT):
		for i in range(Field.TILE_WIDTH):
			var v = tile_front.get_cell(i, j)
			if _create_obj(i, j, v):
				# 生成したらタイルの情報は消しておく.
				tile_front.set_cell(i, j, Field.eTile.NONE)
	
	# スタート地点が未設定の場合はランダムな位置にプレイヤーを出現させる.
	if _player == null:
		var p = Field.search_random_none()
		_create_player(p.x, p.y)
	
	# 共通モジュールをセットアップする.
	var layers = {
		"crate": _crate_layer,
	}
	Common.setup(_player, layers)

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
	_obj_layer.add_child(_player)

## 荷物の生成.
func _create_crate(i:int, j:int, id:int) -> void:
	var crate = CrateObj.instance()
	# Spriteの更新があるので先に add_child() する.
	_crate_layer.add_child(crate)
	crate.setup(i, j, id)

## 更新.
func _process(delta:float) -> void:
	match _state:
		eState.MAIN:
			_update_main(delta)
		eState.STAGE_CLEAR:
			_update_stage_clear()
	
## 更新 > メイン.
func _update_main(delta:float) -> void:
	_timer += delta
	
	if Input.is_action_just_pressed("ui_reset"):
		# リセットボタン.
		get_tree().change_scene("res://Main.tscn")
	
	# プレイヤーの更新.
	_player.proc(delta)
	
	# 荷物の更新.
	for crate in _crate_layer.get_children():
		crate.proc(delta)
	
	# UIの更新.
	_update_ui(delta)
	
	# ステージクリアしたかどうか.
	if Field.is_stage_clear():
		_ui_redo.visible = false
		_ui_undo.visible = false
		_ui_reset.visible = false
		_state = eState.STAGE_CLEAR

## 更新 > ステージクリア.
func _update_stage_clear() -> void:
	_ui_caption.visible = true
	_ui_caption.text = "COMPLETED"
	if Common.is_final_level():
		_ui_caption.text = "ALL LEVELS COMPLETED!"
	
	if Input.is_action_just_pressed("ui_accept"):
		# 次のステージに進む.
		Common.next_level()
		if Common.completed_all_level():
			# 全ステージクリアしたら最初から.
			Common.reset_level()
		get_tree().change_scene("res://Main.tscn")

func _update_ui(_delta:float) -> void:
	_ui_step.visible = false
	_ui_undo.visible = false
	_ui_redo.visible = false
	var cnt_undo = Common.count_undo()
	if cnt_undo > 0:	
		_ui_undo.visible = true
		_ui_step.visible = true
		_ui_step.text = "STEP:%d"%cnt_undo
	
	if _DEBUG_UNDO_LOG:
		# 履歴をデバッグ用表示.
		for data in Common.get_undo_list():
			var d:Common.ReplayData = data
			var buf = "\n"
			var dir1 = Direction.to_name(d.player_dir)
			var dir2 = Direction.to_name(d.crate_dir)
			buf += "(%d %d)%s (%d %d)%s"%[d.player_pos.x, d.player_pos.y, dir1, d.crate_pos.x, d.crate_pos.y, dir2]
			_ui_step.text += buf
	
	if Common.count_redo() > 0:
		_ui_redo.visible = true
	


func _on_Button_pressed() -> void:
	if _state == eState.MAIN:
		# undoを実行する.
		Common.undo()

func _on_RedoButton_pressed() -> void:
	if _state == eState.MAIN:
		# redoを実行する.
		Common.redo()


func _on_ResetButton_pressed() -> void:
	if _state == eState.MAIN:
		# ステージをやり直す.
		get_tree().change_scene("res://Main.tscn")
