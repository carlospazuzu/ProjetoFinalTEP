extends Node2D

const BASE_NUMBER: int = 50

var has_started: bool = false
var is_allowed_to_shoot: bool = false
var is_allowed_to_aim: bool = false

var time_elapsed: float = 0.0

var current_time: int = 3

var is_in_right_position: bool = false

var is_player_one: bool = true

var score_p1 = 0
var score_p2 = 0

var sfx1 = preload('res://resources/audio/load1.wav')
var sfx2 = preload('res://resources/audio/load2.wav')
var sfx3 = preload('res://resources/audio/tiro.wav')


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
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

func _on_DuelarTouchButton_pressed():
	has_started = true
	if not is_in_right_position:
		show_help_image()
		
func show_help_image():
	$PauDaPlaca.visible = false
	$DuelarTouchButton.visible = false
	$HelpImage.visible = true
	$PlayerNumber.visible = false
	
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
			

class MyCustomSorter:
	static func sort_descending(a, b):
		if a['pontos'] > b['pontos']:
			return true
#		elif a['reacao'] > b['reacao']:
#			return true
#		elif a['precisao'] > b['precisao']:
#			return true
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
			

func _on_ShootTouchButton_pressed():
	var x = Input.get_accelerometer().x

	if is_allowed_to_shoot:
		$CountDownImage.visible = false
		var final_score = (BASE_NUMBER / time_elapsed) * ((200 - (abs(x) * 100)) / 2)
		
		if is_player_one:
			score_p1 = int(final_score)
			$ScoreTextPlayer1.text = _getProperSpaces(final_score) + str(int(final_score)) + ' PTS' 
			$ReactionTimeTextP1.text = 'REACAO: ' + str(time_elapsed) + ' s'
			$PrecisionTextP1.text = 'PRECISAO: ' + str(int((200 - (abs(x) * 100)) / 2)) + '%'
			_save_record_to_file(int(final_score), x)
		else:
			score_p2 = int(final_score)
			$ScoreTextPlayer2.text = _getProperSpaces(final_score) + str(int(final_score)) + ' PTS' 
			$ReactionTimeTextP2.text = 'REACAO: ' + str(time_elapsed) + ' s'
			$PrecisionTextP2.text = 'PRECISAO: ' + str(int((200 - (abs(x) * 100)) / 2)) + '%'
			
		$ShotSFX.stream = sfx3
		$ShotSFX.play()		
		show_final_score_itens()
			
func show_final_score_itens():
	$Bangg.visible = true
	$ShootTouchButton.visible = false
	$NextPlayerButton.visible = true
		
func _on_NextPlayerButton_pressed():
	$Bangg.visible = false
	if is_player_one:
		is_player_one = false
		$PlayerNumber.text = "jogador  2"
		$PlayerNumber.visible = true
		$NextPlayerButton.visible = false
		$DuelarTouchButton.visible = true
		$PauDaPlaca.visible = true
		$ShootTouchButton.visible = true
		$CountDownImage.visible = true
		$CountDownImage.texture = null
		is_in_right_position = false
		is_allowed_to_aim = false
		is_allowed_to_shoot = false
		time_elapsed = 0.0
		current_time = 3
		
	else:
		$DuelarTouchButton.visible = false
		$ShootTouchButton.visible = false
		$FinalScoreBoard.visible = true
		$Player1Text.visible = true
		$Player2Text.visible = true
		$ScoreTextPlayer1.visible = true
		$ScoreTextPlayer2.visible = true
		$ReactionTimeTextP1.visible = true
		$ReactionTimeTextP2.visible = true
		$PrecisionTextP1.visible = true
		$PrecisionTextP2.visible = true
		$RestartButton.visible = true
		$HomeScreenButton.visible = true
		$NextPlayerButton.visible = false
		get_results()
	
func _on_RestartButton_pressed():
	get_tree().reload_current_scene()

func _on_HomeScreenButton_pressed():
	get_tree().change_scene("res://scenes/tests/Tests.tscn")

func get_results():
	if score_p1 > score_p2:
		$PlayerWin.text = "jogador  1\n    vencedor!"
	elif score_p2 > score_p1:
		$PlayerWin.text = "jogador  2\n    vencedor!"
	else:
		$PlayerWin.text = "empate!"
		
	$PlayerWin.visible = true
