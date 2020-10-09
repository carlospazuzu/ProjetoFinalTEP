extends Node2D


var has_started: bool = false
var current_time: int = 3

var is_in_right_position: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:	
		show_help_image()
		# start_countdown()	
		pass
		# emit_signal()


func _process(delta):
	if Input.get_accelerometer().x >= -10 and Input.get_accelerometer().x <= -8:
		is_in_right_position = true
	else:
		is_in_right_position = false

	if is_in_right_position:
		start_countdown()
		
	var acc = Input.get_accelerometer()
		
	$AccelerometerHelper.text = 'X = ' + str(acc.x) + ' Y = ' + str(acc.y) + ' Z = ' + str(acc.z)

func show_help_image():
	$PauDaPlacaTreino.visible = false
	$TreinarTouchButton.visible = false
	$HelpImage.visible = true


func start_countdown():
	$CountdownTimer.start()
	if not has_started:		
		$CountDownImage.texture = load('res://resources/others/Cont3.png')
		has_started = true


func _on_TouchScreenButton_pressed():	
	show_help_image()
	# start_countdown()
	pass # Replace with function body.


func _on_CountdownTimer_timeout():
	current_time -= 1
	if current_time >= 1:
		$CountDownImage.texture = load('res://resources/others/Cont' + str(current_time) +'.png')
		$CountdownTimer.start()
	else:
		$CountDownImage.texture = load('res://resources/others/ContFogo.png')
		$CountdownTimer.stop()
	
