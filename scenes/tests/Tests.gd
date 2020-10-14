extends Node2D


var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _input(event):
	#if event is InputEventMouseButton:
		#get_tree().change_scene("res://scenes/treino/TreinoScreen.tscn")	


func _on_TreinoButton_pressed():
	get_tree().change_scene("res://scenes/treino/TreinoScreen.tscn")
	
func _on_DueloButton_pressed():
	get_tree().change_scene("res://scenes/duelo/DueloScreen.tscn")


func _on_MeusDisparosButton_pressed():
	count += 5
	$Text.text = str(count)	
	pass # Replace with function body.
