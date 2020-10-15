extends Node2D

func _ready():
	Data.load()
	$PontosContainer/um.text = str(int(Data.records[0].pontos))
	$PontosContainer/dois.text = str(int(Data.records[1].pontos))
	$PontosContainer/tres.text = str(int(Data.records[2].pontos))
	$PontosContainer/quarto.text = str(int(Data.records[3].pontos))
	$PontosContainer/cinco.text = str(int(Data.records[4].pontos))


#func _process(delta):
#	pass


func _on_ReturnHomeButton_pressed():
	get_tree().change_scene("res://scenes/tests/Tests.tscn")
	
