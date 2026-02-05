@tool
extends DialogicPortrait


func _update_portrait(passed_character:DialogicCharacter, passed_portrait:String) -> void:
	apply_character_and_portrait(passed_character, passed_portrait)
	if passed_portrait == "":
		passed_portrait = passed_character['default_portrait']

func _get_covered_rect() -> Rect2:
	return Rect2($Sprite.position, $Sprite.get_rect().size)
