extends Control

@export var gdt: GDT

@export var browser: Tree
@export var viewer: Tree

var _viewer_header: TreeItem

var _selected: Dictionary[StringName, TreeItem]
var _viewer_tree: Dictionary[StringName, TreeItem]


func _ready() -> void:
	var root: TreeItem = browser.create_item()

	var item_zombie: TreeItem = browser.create_item(root)
	item_zombie.set_text(0, 'Zombies')
	item_zombie.set_selectable(0, false)

	var item_multiplayer: TreeItem = browser.create_item(root)
	item_multiplayer.set_text(0, 'Multiplayer')
	item_multiplayer.set_selectable(0, false)

	var item_campaign: TreeItem = browser.create_item(root)
	item_campaign.set_text(0, 'Campaign')
	item_campaign.set_selectable(0, false)

	var item_other: TreeItem = browser.create_item(root)
	item_other.set_text(0, 'Other')
	item_other.set_selectable(0, false)

	for weapon_name: String in gdt.entries.keys():
		var mode: TreeItem

		if weapon_name.ends_with('_zm'):
			mode = item_zombie
		elif weapon_name.ends_with('_mp'):
			mode = item_multiplayer
		elif weapon_name.ends_with('_cp'):
			mode =  item_campaign
		else:
			mode = item_other

		var category: TreeItem = browser.create_item(mode)
		category.set_text(0, weapon_name)


func _on_browser_item_selected(weapon_name: StringName, column: int) -> void:
	_viewer_header.set_text(column, weapon_name)

	var weapon_data: GDF = gdt.entries.get(weapon_name)

	for key: String in weapon_data.properties.keys():
		var value: String = weapon_data.properties.get(key)

		var item: TreeItem = _viewer_tree.get(key)
		if item == null:
			item = viewer.create_item()
			_viewer_tree.set(key, item)

			item.set_text(0, key)
			item.set_selectable(0, false)

		#item.set_editable(column, true)
		item.set_selectable(column, false)

		if value.is_valid_int():
			var num: int = value.to_int()

			# Hasty boolean check.
			#if num == 0 or num == 1:
			#	item.set_cell_mode(column, TreeItem.CELL_MODE_CHECK)
			#	item.set_checked(column, num == 1)
			# Definitely an integer.
			#else:
			item.set_text(column, value)
		elif value.is_valid_float():
			item.set_text(column, value)
		else:
			item.set_text(column, value)


func _on_browser_multi_selected(item: TreeItem, _column: int, selected: bool) -> void:
	var weapon_name: StringName = item.get_text(0)

	if selected:
		_selected.set(weapon_name, item)
	else:
		_selected.erase(weapon_name)
	
	# Rebuild.
	viewer.clear()
	_viewer_tree.clear()

	_viewer_header = viewer.create_item()

	for column: int in _selected.keys().size():
		_on_browser_item_selected(_selected.keys().get(column), column + 1)

	printt(weapon_name, selected)
