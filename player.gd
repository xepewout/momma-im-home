extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0
signal hit
signal dead
var wind
var windDirection
var playerHealth = 3

func _physics_process(_delta: float) -> void:

	var direction := Input.get_axis("MOVE_LEFT", "MOVE_RIGHT")
	if wind:
		direction = windDirection
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_enemy_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		playerHealth -= 1
		hit.emit()
		if playerHealth == 0:
			dead.emit()
			self.queue_free()
		
		
func _applyWind(direction: float):
	wind = true
	windDirection = direction/(abs(direction)/2)
	
func _removeWind():
	wind = false
	windDirection = 0
		
