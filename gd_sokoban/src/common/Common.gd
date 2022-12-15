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
	var undo_list = []
	var redo_list = []
	func reset():
		undo_list.clear()
		redo_list.clear()
		
	func add_undo(d:ReplayData):
		undo_list.append(d)
	func count_undo() -> int:
		return undo_list.size()
	func undo(player:Player):
		if undo_list.empty():
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

# ---------------------------------------
# vars.
# ---------------------------------------
var _player:Player = null
var _layers = []
var _replay_mgr = ReplayMgr.new()

# ---------------------------------------
# public functions.
# ---------------------------------------
## セットアップ.
func setup(player, layers):
	_player = player
	_layers = layers
	
	_replay_mgr.reset()

## CanvasLayerを取得する.
func get_layer(name:String) -> CanvasLayer:
	return _layers[name]
	
func add_undo(data:ReplayData) -> void:
	_replay_mgr.add_undo(data)
func count_undo() -> int:
	return _replay_mgr.count_undo()
func get_undo_list():
	return _replay_mgr.undo_list
## undoを実行する.
func undo():
	_replay_mgr.undo(_player)
# ---------------------------------------
# private functions.
# ---------------------------------------
