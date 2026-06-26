@tool
class_name GDTImportPlugin
extends EditorImportPlugin

func _get_importer_name() -> String:
	return "righteous.gdt"

func _get_visible_name() -> String:
	return "GDT"

func _get_recognized_extensions() -> PackedStringArray:
	return ["gdt"]

func _get_save_extension() -> String:
	return "tres"

func _get_resource_type() -> String:
	return "GDT"

func _get_preset_name(_preset_index: int) -> String:
	return "Default"

func _get_import_options(_path: String, _preset_index: int) -> Array[Dictionary]:
	return [{"name": "my_option", "default_value": false}]

func _import(source_file: String, save_path: String, _options: Dictionary, _platform_variants: Array[String], _gen_files: Array[String]) -> int:
	var file: FileAccess = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		return FAILED
	var gdt: GDT = _parse(file)
	var filename: String = save_path + "." + _get_save_extension()
	return ResourceSaver.save(gdt, filename)

func _parse(file: FileAccess) -> GDT:
	var gdt: GDT = GDT.new()
	var depth: int = 0
	var is_type: bool = false

	var entry: String = ""
	var data: Dictionary = {}
	var key: String = ""
	var key_set: bool = false

	while not file.eof_reached():
		var token: String = _next_token(file)

		match token:
			'{':
				depth += 1
				continue
			'}':
				depth -= 1
				continue
			'(':
				is_type = true
				continue
			')':
				is_type = false
				continue

		if is_type:
			data.set("type", token)
		elif depth == 1:
			entry = token
			data = {}
			key = ""
			key_set = false
			gdt.entries.set(entry, data)
		elif depth == 2:
			if key_set:
				data.set(key, token)
				key = ""
				key_set = false
			else:
				key = token
				key_set = true

	return gdt

func _next_token(file: FileAccess) -> String:
	var token: String = ""
	var is_string: bool = false

	while not file.eof_reached():
		var bits: int = file.get_8()
		var c: String = char(bits)

		# Execute until string is built.
		# Exclude quote characters too.
		if c == '"':
			is_string = not is_string

			if not is_string:
				break

			continue
		if is_string:
			token += c
			continue

		# Expected to be a single character at this point!
		if token.is_empty():
			# Exclude non-token characters!
			if c not in ['{', '}', '(', ')']:
				continue

			token = c

		break

	if is_string:
		printerr('Unterminated string: "%s"' % token)

	return token
