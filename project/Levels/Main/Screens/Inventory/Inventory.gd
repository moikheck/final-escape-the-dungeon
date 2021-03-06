extends Control


func _ready():
	visible = false


func show_inventory(primary_weapon, secondary_weapon, health_amount):
	visible = true
	$AnimationPlayer.stop()
	$AnimationPlayer.play("open")
	$PrimaryWeapon.texture = primary_weapon.get_texture()
	$SecondaryWeapon.texture = secondary_weapon.get_texture()
	$HealthLabel.text = str(health_amount) + "/5"


func hide_inventory():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("close")


func _on_ResumeButton_pressed():
	get_parent().unpause()


func _on_RestartButton_pressed():
	var _ignored = get_tree().change_scene("res://Levels/Main/Level.tscn")


func _on_TitleButton_pressed():
	var _ignored = get_tree().change_scene("res://Levels/TitleScreen.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "close":
		visible = false


func _on_HowToPlay_pressed():
	print('press')
	$InstructionsPopup.popup()
