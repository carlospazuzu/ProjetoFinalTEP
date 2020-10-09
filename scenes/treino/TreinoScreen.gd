extends Node2D


var has_started: bool = false
var current_time: int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:
		pass
		# emit_signal()


func _on_TouchScreenButton_pressed():
	$CountdownTimer.start()
	if not has_started:
		$PauDaPlacaTreino.visible = false
		$TreinarTouchButton.visible = false
		$CountDownImage.texture = load('res://resources/others/Cont3.png')
		has_started = true
	pass # Replace with function body.


func _on_CountdownTimer_timeout():
	current_time -= 1
	if current_time >= 1:
		$CountDownImage.texture = load('res://resources/others/Cont' + str(current_time) +'.png')
		$CountdownTimer.start()
	else:
		$CountDownImage.texture = load('res://resources/others/ContFogo.png')
		$CountdownTimer.stop()
	
