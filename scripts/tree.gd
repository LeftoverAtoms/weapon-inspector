extends Control

@export var gdt: GDT

@export var browser: Tree
@export var viewer: Tree


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


func _on_browser_item_selected() -> void:
	viewer.clear()

	var weapon_name: String = browser.get_selected().get_text(0)
	var weapon_data: GDF = gdt.entries.get(weapon_name)

	for key: String in weapon_data.properties.keys():
		var value: String = weapon_data.properties.get(key)

		var item: TreeItem = viewer.create_item()
		item.set_text(0, key)
		item.set_selectable(0, false)

		#item.set_editable(1, true)
		item.set_selectable(1, false)

		if value.is_valid_int():
			var num: int = value.to_int()

			# Hasty boolean check.
			if num == 0 or num == 1:
				item.set_cell_mode(1, TreeItem.CELL_MODE_CHECK)
				item.set_checked(1, num == 1)
			# Definitely an integer.
			else:
				item.set_text(1, value)
		elif value.is_valid_float():
			item.set_text(1, value)
		else:
			item.set_text(1, value)
