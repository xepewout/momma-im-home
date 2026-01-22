extends Area2D
var xSize = 64.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= Global.game_speed
	xSize += delta * 1000
	$CollisionShape2D.shape.set_size(Vector2(xSize,64))


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body._applyWind(body.position.x - position.x)
			
func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		body._removeWind()
		
