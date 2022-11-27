extends Node

var player
var camera

var levelSize = Vector2(2500,1000)
var floorCount = 0

enum State {GAME_OVER, PLAYING, NEXT_LEVEL, MENU}
var state = State.MENU
