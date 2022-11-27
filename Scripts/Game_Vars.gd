extends Node

var player
var camera

var levelSize = Vector2(2500,1500)

enum State {GAME_OVER, PLAYING, MENU}
var state = State.MENU
