extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func updateHealth(health):
	$HealthLabel.text = ("Player Health: "  + str(health))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$DistanceLabel.text = (str($"..".distance))

func _on_leaf_button_toggled(leafOn):
	$"..".leaf = leafOn
	print("leaf", leafOn)
	$".."._changeGameType()


func _on_rock_button_toggled(toggled_on: bool) -> void:
	$"..".rock = toggled_on
	$".."._changeGameType()

func _on_bug_button_toggled(toggled_on: bool) -> void:
	$"..".bug = toggled_on
	$"..".changeGameType()

func _on_salt_button_toggled(toggled_on: bool) -> void:
	$"..".salt = toggled_on
	$"..".changeGameType()

func _on_candy_button_toggled(toggled_on: bool) -> void:
	$"..".candy = toggled_on
	$"..".changeGameType()
