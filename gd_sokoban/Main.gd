extends Node2D

const PlayerObj = preload("res://src/player/Player.tscn")
const Point2 = preload("res://src/common/Point2.gd")

onready var _tile_back = $TileMapBack
onready var _tile_front = $TileMapFront
onready var _player:Player = null

func _ready() -> void:
	print("back --------------------")
	for j in range(Common.TILE_HEIGHT):
		var buf = ""
		for i in range(Common.TILE_WIDTH):
			var v = _tile_back.get_cell(i, j)
			buf += "%2d, "%v
		print(buf)
	print("front --------------------")
	for j in range(Common.TILE_HEIGHT):
		var buf = ""
		for i in range(Common.TILE_WIDTH):
			var v = _tile_front.get_cell(i, j)
			if _create_obj(i, j, v):
				# 生成したらタイルの情報は消しておく.
				_tile_front.set_cell(i, j, Common.eTile.NONE)
			buf += "%2d, "%v
		print(buf)
	
	if _player == null:
		var p = _search_random_none()
		_create_player(p.x, p.y)
		
func _search_random_none() -> Point2:
	var arr = []
	for j in range(Common.TILE_HEIGHT):
		for i in range(Common.TILE_WIDTH):
			if _tile_front.get_cell(i, j) == Common.eTile.NONE:
				arr.append(Point2.new(i, j))
	
	arr.shuffle()
	return arr[0]
	
func _create_player(i:int, j:int) -> void:
	_player = PlayerObj.instance()
	var p = Point2.new(i, j)
	_player.set_pos(p)
	add_child(_player)

func _create_obj(i:int, j:int, id:int) -> bool:
	match id:
		Common.eTile.START:
			_create_player(i, j)
			return true
	
	return false

func _draw() -> void:
	for j in range(8):
		var py = j * Common.TILE_SIZE
		for i in range(12):
			var px = i * Common.TILE_SIZE
			var pos = Vector2(px, py)
			var size = Vector2(Common.TILE_SIZE, Common.TILE_SIZE)
			var rect = Rect2(pos, size)
			draw_rect(rect, Color.silver, false)
