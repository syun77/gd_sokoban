extends Node2D
# ===========================
# メイン.
# ===========================

# ---------------------------------------
# preload.
# ---------------------------------------
const PlayerObj = preload("res://src/player/Player.tscn")
const Point2 = preload("res://src/common/Point2.gd")

# ---------------------------------------
# onready.
# ---------------------------------------
onready var _tile_back = $TileMapBack
onready var _tile_front = $TileMapFront
onready var _player:Player = null

# ---------------------------------------
# private functions.
# ---------------------------------------
func _ready() -> void:
	print("back --------------------")
	for j in range(Field.TILE_HEIGHT):
		var buf = ""
		for i in range(Field.TILE_WIDTH):
			var v = _tile_back.get_cell(i, j)
			buf += "%2d, "%v
		print(buf)
	print("front --------------------")
	for j in range(Field.TILE_HEIGHT):
		var buf = ""
		for i in range(Field.TILE_WIDTH):
			var v = _tile_front.get_cell(i, j)
			if _create_obj(i, j, v):
				# 生成したらタイルの情報は消しておく.
				_tile_front.set_cell(i, j, Field.eTile.NONE)
			buf += "%2d, "%v
		print(buf)
	
	# フィールドをセットアップする.
	Field.setup(_tile_front)
	
	if _player == null:
		var p = Field.search_random_none()
		_create_player(p.x, p.y)

	
func _create_player(i:int, j:int) -> void:
	_player = PlayerObj.instance()
	var p = Point2.new(i, j)
	_player.set_pos(p)
	add_child(_player)

func _create_obj(i:int, j:int, id:int) -> bool:
	match id:
		Field.eTile.START:
			_create_player(i, j)
			return true
	
	return false

