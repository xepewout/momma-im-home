extends CharacterBody2D


var SPEED = 500.0
const JUMP_VELOCITY = -400.0
signal hit
signal dead
var wind
var windDirection
var playerHealth = 3
var candyPower = false
var region_size = Vector2(48, 30)
var region_position = Vector2(48, 1)
#leaf = slower fall rate
#salt = faster move speed
#dead bug = two lives
#candy = break through spikes on cooldown
#rock = faster fall rate

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("MOVE_LEFT", "MOVE_RIGHT")
	if wind:
		direction = windDirection
	if direction:
		velocity.x = direction * SPEED * (Global.game_speed / (Global.game_speed - 1))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * (Global.game_speed / (Global.game_speed - 1)))
	move_and_slide()

func _on_enemy_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		playerHealth -= 1
		hit.emit()
		region_size = region_size - Vector2(13,0)
		$Sprite2D.texture.region = Rect2(region_position, region_size)
	if area.is_in_group("spikes") or playerHealth == 0:
		dead.emit()
		self.queue_free()
			
func _applyWind(direction: float):
	wind = true
	windDirection = direction/(abs(direction)/2)
	
func _removeWind():
	wind = false
	windDirection = 0
	
func _toggleCamera():
	$Camera2D.enabled = !$Camera2D.enabled
		
