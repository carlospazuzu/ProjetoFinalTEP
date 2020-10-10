extends Node2D

const BASE_NUMBER: int = 10

var has_started: bool = false
var is_allowed_to_shoot: bool = false
var is_allowed_to_aim: bool = false

var time_elapsed: float = 0.0

var current_time: int = 3

var is_in_right_position: bool = false

var sfx1 = preload('res://resources/audio/load1.wav')
var sfx2 = preload('res://resources/audio/load2.wav')
var sfx3 = preload('res://resources/audio/tiro.wav')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):	
	$has_started_Text.text = 'Has_Started = ' + str(has_started) 	
	

	if not has_started:
		if Input.get_accelerometer().x >= -10 and Input.get_accelerometer().x <= -8:
			is_in_right_position = true
		else:
			is_in_right_position = false
			
			
	if is_allowed_to_aim:
		time_elapsed += delta * 100
		if Input.get_accelerometer().x >= -1 and Input.get_accelerometer().x <= 1:
			is_allowed_to_shoot = true		
		else:
			is_allowed_to_shoot = false

	if is_in_right_position and not has_started:
		var d = randi() % 2
		$SoundFX.stream = sfx1 if d == 0 else sfx2
		$SoundFX.play()
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
		$HelpImage.visible = false
		$CountDownImage.texture = load('res://resources/others/Cont3.png')
		has_started = true



func _on_CountdownTimer_timeout():
	current_time -= 1
	if current_time >= 1:
		$CountDownImage.texture = load('res://resources/others/Cont' + str(current_time) +'.png')
		$CountdownTimer.start()
	else:
		$CountDownImage.texture = load('res://resources/others/ContFogo.png')
		$CountdownTimer.stop()
		is_allowed_to_aim = true
	


func _on_ShootTouchButton_pressed():
	var x = Input.get_accelerometer().x
	$ScoreText.text = 'AHSUYAHUSAUHSHUASUAHSUAHSUAHSUA'
	if is_allowed_to_shoot:
		$CountDownImage.visible = false
		var final_score = (BASE_NUMBER / time_elapsed) * (100 - (abs(x) * 100))
		$ScoreText.text = 'FINAL SCORE = ' + str(final_score)
		$SoundFX.stream = sfx3
		$SoundFX.play()


func _on_TreinarTouchButton_released():
	if not has_started:
		show_help_image()
	pass # Replace with function body.
