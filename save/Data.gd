extends Node

const FILE_NAME = "user://save-data.json"
var record = {
			"pontos": 0,
			"precisao": 0,
			"reacao": 0.0,
		}
var records = [record,record,record,record,record]

func save():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(records))
	file.close()

func load():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_ARRAY:
			records = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
