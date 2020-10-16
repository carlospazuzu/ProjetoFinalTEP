extends Node2D

func _ready():
	if not BG_Audio.get_bg_audio().is_playing():
		BG_Audio.bg_audio_play()
		
func _process(delta):
	pass

func _on_TreinoButton_pressed():
	get_tree().change_scene("res://scenes/treino/TreinoScreen.tscn")
	
func _on_DueloButton_pressed():
	get_tree().change_scene("res://scenes/duelo/DueloScreen.tscn")

func _on_MeusDisparosButton_pressed():
	get_tree().change_scene("res://scenes/records/RecordsScreen.tscn")
