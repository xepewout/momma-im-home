extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.color = Color(randf(), randf(), randf())
	
func _process(_delta: float) -> void:
	position.y -= Global.game_speed
