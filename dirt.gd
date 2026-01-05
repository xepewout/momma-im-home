extends RigidBody2D
var tempDespawnHit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tempDespawnHit = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += Global.game_speed * .5

func _addHit():
	tempDespawnHit+=1
