extends Node2D

const BASE_NUMBER: int = 50

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
	
	if has_started:
		if Input.get_accelerometer().x >= -10 and Input.get_accelerometer().x <= -8:
			is_in_right_position = true
		else:
			is_in_right_position = false
			
	if is_allowed_to_aim:
		time_elapsed += delta
		if Input.get_accelerometer().x >= -1 and Input.get_accelerometer().x <= 1:
			is_allowed_to_shoot = true		
		else:
			is_allowed_to_shoot = false

	if is_in_right_position and has_started:
		var d = randi() % 2
		$SoundFX.stream = sfx1 if d == 0 else sfx2
		$SoundFX.play()
		start_countdown()
		
	var acc = Input.get_accelerometer()
	var started = str(has_started)
		
	$AccelerometerHelper.text = 'X = ' + str(acc.x) + ' Y = ' + str(acc.y) + ' Z = ' + str(acc.z) + ' has_starded = ' + started

func show_help_image():
	$PauDaPlacaTreino.visible = false
	$TreinarTouchButton.visible = false
	$HelpImage.visible = true
	
func show_final_score_itens():
	$Bangg.visible = true
	$RestartButton.visible = true
	$HomeScreenButton.visible = true
	$FinalScoreBoard.visible = true
	$ShootTouchButton.visible = false		

func start_countdown():
	$CountdownTimer.start()
	if has_started:		
		$HelpImage.visible = false
		$CountDownImage.texture = load('res://resources/others/Cont3.png')
		has_started = false

func _on_CountdownTimer_timeout():
	current_time -= 1
	if current_time >= 1:
		$CountDownImage.texture = load('res://resources/others/Cont' + str(current_time) +'.png')
		$CountdownTimer.start()
	else:
		$CountDownImage.texture = load('res://resources/others/ContFogo.png')
		$CountdownTimer.stop()
		is_allowed_to_aim = true

func _getProperSpaces(score):
	var digits = 4 - len(str(int(score)))
	
	match digits:
		0:
			return ''
		1:
			return ' '
		2:
			return '  '
		3:
			return '    '

	
func _on_ShootTouchButton_pressed():
	var x = Input.get_accelerometer().x

	if is_allowed_to_shoot:
		$CountDownImage.visible = false
		var final_score = (BASE_NUMBER / time_elapsed) * (100 - (abs(x) * 100))
		$ScoreText.text = _getProperSpaces(final_score) + str(int(final_score)) + ' PTS' 
		$ReactionTimeText.text = 'REACAO: ' + str(time_elapsed) + ' s'
		$PrecisionText.text = 'PRECISAO: ' + str(int(100 - (abs(x) * 100)))+ '%'
		$SoundFX.stream = sfx3
		$SoundFX.play()		
		show_final_score_itens()

func _on_TreinarTouchButton_released():
	has_started = true
	if not is_in_right_position:
		show_help_image()

func _on_HomeScreenButton_pressed() -> void:
	get_tree().change_scene("res://scenes/tests/Tests.tscn")

func _on_RestartButton_pressed() -> void:
	get_tree().reload_current_scene()
