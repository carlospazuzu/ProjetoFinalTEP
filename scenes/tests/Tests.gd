extends Node2D


var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TreinoButton_pressed():
	get_tree().change_scene("res://scenes/treino/TreinoScreen.tscn")
	pass # Replace with function body.
	
func _on_DueloButton_pressed():
	count -= 1
	$Text.text = str(count)	
	pass # Replace with function body.


func _on_MeusDisparosButton_pressed():
	count += 5
	$Text.text = str(count)	
	pass # Replace with function body.
