extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0
signal hit


func _physics_process(_delta: float) -> void:

	var direction := Input.get_axis("MOVE_LEFT", "MOVE_RIGHT")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_enemy_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		hit.emit()
		
