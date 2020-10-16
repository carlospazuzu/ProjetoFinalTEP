extends Node2D

func _ready():
	#$bg_audio.play()
	Data.load()
	var lenData = len(Data.records)
	var cont = 0
	
	for c in $PontosContainer.get_children():
		if cont == lenData:
			break
		c.text = str(Data.records[cont].pontos)
		cont += 1
		
	cont = 0
	
	for c in $ReacaoContainer.get_children():
		if cont == lenData:
			break
		c.text = str(Data.records[cont].reacao) + " s"
		cont += 1
		
	cont = 0
	
	for c in $PrecisaoContainer.get_children():
		if cont == lenData:
			break
		c.text = str(Data.records[cont].precisao) + "%"
		cont += 1
	
func _process(delta):
	pass


func _on_ReturnHomeButton_pressed():
	get_tree().change_scene("res://scenes/tests/Tests.tscn")
	
