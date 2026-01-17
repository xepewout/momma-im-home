extends Area2D
const WEB = preload("res://web.tscn")
var web = WEB.instantiate()
var webTargetPos
var t = 0.0
@onready var webString: Line2D = $WebString

#want to spawn hanging under a platform then shoot a web to another platform and then swing to it

func _ready() -> void:
	add_child(web)
	web.position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= Global.game_speed
	if web:
		t += delta * 0.4
		web.position = web.position.lerp(webTargetPos,t)
		
		if web.position.distance_to(webTargetPos) < 1:
			t = 0
			t += delta  * 2
			webString.set_point_position(0,$CollisionShape2D.position)
			$CollisionShape2D.position = $CollisionShape2D.position.lerp(webTargetPos,t)
	else:
		t = 0
		t += delta  * 2
		webString.set_point_position(0,$CollisionShape2D.position)
		$CollisionShape2D.position = $CollisionShape2D.position.lerp(webTargetPos,t)
	

func _shootWeb(targetPosition: Vector2):
	webTargetPos = targetPosition
	webString.add_point(Vector2(0,0))
	webString.add_point(webTargetPos)
	webString.width = 1.0
	webString.default_color = Color(1, 1, 1, 1) # Red color
	
	
	
	
