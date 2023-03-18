extends Node
# ===========================
# 共通モジュール.
# ===========================
# ---------------------------------------
# preload.
# ---------------------------------------
const Point2 = preload("res://src/common/Point2.gd")

# ---------------------------------------
# const.
# ---------------------------------------
# 最初のレベル.
const FIRST_LEVEL = 1
# 最終レベル.
const FINAL_LEVEL = 3

# ---------------------------------------
# class.
# ---------------------------------------
## リプレイデータ.
class ReplayData:
	var player_pos = Point2.new()
	var player_dir = Direction.eType.NONE
	var crate_pos = Point2.new()
	var crate_dir = Direction.eType.NONE
	func _init(px:int, py:int, dir:int, cx:int=0, cy:int=0, cdir:int=Direction.eType.NONE) -> void:
		player_pos.set_xy(px, py)
		player_dir = dir
		crate_pos.set_xy(cx, cy)
		crate_dir = cdir

## リプレイ管理.
class ReplayMgr:
	var undo_list = [] # undoリスト.
	var redo_list = [] # redoリスト.
	
	## リセット.
	func reset():
		undo_list.clear()
		redo_list.clear()
	
	## undoを追加する.
	func add_undo(d:ReplayData, is_clear_redo:bool=true):
		undo_list.append(d)
		if is_clear_redo:
			redo_list.clear() # undoが追加されたらredoは消える.
	## undoできる数を取得する.
	func count_undo() -> int:
		return undo_list.size()
	## undoを実行する.
	func undo(player:Player):
		if undo_list.is_empty():
			return # 何もしない.
		
		# 末尾から取り出す.
		var d:ReplayData = undo_list.pop_back()
		player.set_pos(d.player_pos.x, d.player_pos.y, true)
		player.set_dir(d.player_dir)
		if d.crate_dir != Direction.eType.NONE:
			# 荷物の位置も戻す.
			var xprev = d.crate_pos.x
			var yprev = d.crate_pos.y
			var v = Direction.get_point(d.crate_dir)
			var xnow = xprev + v.x
			var ynow = yprev + v.y
			var crate = Field.search_crate(xnow, ynow)
			crate.set_pos(xprev, yprev, true) # 1つ戻す
		
		# redoに追加.
		add_redo(d)

	## redoを追加する.
	func add_redo(d:ReplayData) -> void:
		redo_list.append(d)
	## redoできる数を取得する.
	func count_redo() -> int:
		return redo_list.size()
	## redoを実行する.
	func redo(player:Player) -> void:
		if redo_list.is_empty():
			return # 何もしない.
		
		# 末尾から取り出す.
		var d:ReplayData = redo_list.pop_back()
		var p_vdir = Direction.get_point(d.player_dir)
		var px = d.player_pos.x + p_vdir.x
		var py = d.player_pos.y + p_vdir.y
		player.set_pos(px, py, true)
		player.set_dir(d.player_dir)
		if d.crate_dir != Direction.eType.NONE:
			# 荷物の位置も戻す.
			var xprev = d.crate_pos.x
			var yprev = d.crate_pos.y
			var v = Direction.get_point(d.crate_dir)
			var xnext = xprev + v.x
			var ynext = yprev + v.y
			var crate = Field.search_crate(xprev, yprev)
			crate.set_pos(xnext, ynext, true) # 1つ進める.
		
		# undoに追加 (redoは消さない).
		add_undo(d, false)
# ---------------------------------------
# vars.
# ---------------------------------------
var _player:Player = null
var _layers = []
var _replay_mgr = ReplayMgr.new()
var _level = FIRST_LEVEL

# ---------------------------------------
# public functions.
# ---------------------------------------
## レベルを最初に戻す.
func reset_level() -> void:
	_level = FIRST_LEVEL
## レベルを次に進める.
func next_level() -> void:
	_level += 1
## 最終レベルを終えたかどうか.
func completed_all_level() -> bool:
	return _level > FINAL_LEVEL
func is_final_level() -> bool:
	return _level == FINAL_LEVEL
## 現在のレベル番号を取得する.
func get_level() -> int:
	return _level
## レベルシーンのパスを取得する.
func get_level_scene(level:int=0) -> String:
	if level <= 0:
		# 指定がない場合は現在のレベルを使用する.
		level = _level
	
	return "res://src/level/level%02d.tscn"%level

## セットアップ.
func setup(player, layers):
	_player = player
	_layers = layers
	
	_replay_mgr.reset()

## CanvasLayerを取得する.
func get_layer(name:String) -> CanvasLayer:
	return _layers[name]

## ■UNDO関連.	
func add_undo(data:ReplayData) -> void:
	_replay_mgr.add_undo(data)
func count_undo() -> int:
	return _replay_mgr.count_undo()
func get_undo_list():
	return _replay_mgr.undo_list
## undoを実行する.
func undo():
	_replay_mgr.undo(_player)
## ■REDO関連.
func count_redo() -> int:
	return _replay_mgr.count_redo()
## redoを実行する.
func redo() -> void:
	_replay_mgr.redo(_player)
# ---------------------------------------
# private functions.
# ---------------------------------------
