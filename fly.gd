extends Area2D
const PEA = preload("res://pea.tscn")
var player
var pea 
var peaTargetPos
var t = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= Global.game_speed
	t += delta * .1
	if pea and peaTargetPos:
		pea.position = pea.position.lerp(peaTargetPos,t)

func _firePea() -> void:
	pea = PEA.instantiate()
	add_child(pea)
	player = get_tree().get_nodes_in_group("player")
	if(player[0].name == ("Player")):
		peaTargetPos = player[0].position - position
