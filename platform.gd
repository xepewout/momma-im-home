extends Area2D
var isSpiky = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.color = Color(randf(), randf(), randf())
	#var isSpikyChance = randf()
	#if isSpikyChance < .75:
		#_addSpikes()
	
	
func _process(_delta: float) -> void:
	position.y -= Global.game_speed
			
#func _addSpikes():
	#isSpiky = true
	#$ColorRect.color = Color(randf(), randf(), randf())
