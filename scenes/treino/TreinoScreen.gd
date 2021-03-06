extends Node2D

const BASE_NUMBER: int = 50

var has_started: bool = false
var is_allowed_to_shoot: bool = false
var is_allowed_to_aim: bool = false

var time_elapsed: float = 0.0

var current_time: int = 3

var is_in_right_position: bool = false

var previous_final_score: int = 0

var sfx1 = preload('res://resources/audio/load1.wav')
var sfx2 = preload('res://resources/audio/load2.wav')
var sfx3 = preload('res://resources/audio/tiro.wav')

# Called when the node enters the scene tree for the first time.
func _ready():
	BG_Audio.bg_audio_stop()


func _process(delta):	
	
	if has_started:
		if Input.get_accelerometer().x >= -11 and Input.get_accelerometer().x <= -7:
			is_in_right_position = true
			start_countdown()
		else:
			is_in_right_position = false
			
	if not has_started and not $CountdownTimer.is_stopped():
		if not (Input.get_accelerometer().x >= -11 and Input.get_accelerometer().x <= -7):
			is_in_right_position = false
			has_started = true
			show_help_image()
			$CountdownTimer.stop()
			current_time = 3
			$CountDownImage.texture = null
			$ErrorSFX.play()
			
			
	if is_allowed_to_aim:
		time_elapsed += delta
		if Input.get_accelerometer().x >= -2 and Input.get_accelerometer().x <= 2:
			is_allowed_to_shoot = true		
		else:
			is_allowed_to_shoot = false
		
	var acc = Input.get_accelerometer()
	var started = str(has_started)
		
	$AccelerometerHelper.text = 'X = ' + str(acc.x) + ' Y = ' + str(acc.y) + ' Z = ' + str(acc.z) + ' has_starded = ' + started

func show_help_image():
	$PauDaPlacaTreino.visible = false
	$TreinarTouchButton.visible = false
	$HelpImage.visible = true
	
func show_final_score_itens(p_f_s):
	$Bangg.visible = true
	$RestartButton.visible = true
	$HomeScreenButton.visible = true
	$FinalScoreBoard.visible = true
	$ShootTouchButton.visible = false
	if int(Data.records[0].pontos) > p_f_s and p_f_s != 0:
			$NewRecord.visible = true

func start_countdown():
	$CountdownTimer.start()
	if has_started:
		$HelpImage.visible = false
		$CountDownImage.texture = load('res://resources/others/Cont3.png')
		$CountdownFX.play()
		has_started = false

func _on_CountdownTimer_timeout():
	current_time -= 1
	if current_time >= 1:
		$CountdownFX.play()
		$CountDownImage.texture = load('res://resources/others/Cont' + str(current_time) +'.png')
		$CountdownTimer.start()
	else:
		$CountDownImage.texture = load('res://resources/others/ContFogo.png')
		$CountdownTimer.stop()
		$CountdownFinishedSFX.play()
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
		var final_score = (BASE_NUMBER / time_elapsed) * ((200 - (abs(x) * 100)) / 2)
		$ScoreText.text = _getProperSpaces(final_score) + str(int(final_score)) + ' PTS' 
		$ReactionTimeText.text = 'REACAO: ' + str(time_elapsed) + ' s'
		$PrecisionText.text = 'PRECISAO: ' + str(int((200 - (abs(x) * 100)) / 2)) + '%'
		$SoundFX.stream = sfx3
		$SoundFX.play()
		previous_final_score = int(Data.records[0].pontos)
		_save_record_to_file(int(final_score), x)
		show_final_score_itens(previous_final_score)

func _on_TreinarTouchButton_released():
	has_started = true
	if not is_in_right_position:
		show_help_image()

class MyCustomSorter:
	static func sort_descending(a, b):
		if a['pontos'] > b['pontos']:
			return true
		else:
			return false

func _save_record_to_file(final_score, x):
	var precisao = int((200 - (abs(x) * 100)) / 2)
	var record = {
			"pontos": final_score,
			"precisao": precisao,
			"reacao": time_elapsed,
		}
	Data.records.append(record)
	Data.records.sort_custom(MyCustomSorter, "sort_descending")
	if len(Data.records) > 5:
		Data.records.pop_back()
	Data.save()

func _on_HomeScreenButton_pressed() -> void:
	get_tree().change_scene("res://scenes/tests/Tests.tscn")

func _on_RestartButton_pressed() -> void:
	get_tree().reload_current_scene()
