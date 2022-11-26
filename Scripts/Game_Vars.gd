extends Node

var player
var camera

enum State {GAME_OVER, PLAYING, MENU}
var state = State.MENU
