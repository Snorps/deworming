extends Node

var player
var camera
var game

var levelSize = Vector2(2500,1000)

enum State {GAME_OVER, PLAYING, NEXT_LEVEL, MENU}
var state = State.MENU
