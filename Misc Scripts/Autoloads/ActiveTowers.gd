extends Node

# Expected key: Names of towers, as Strings
# Expected value: Another dictionary
#	Expected key: Tag, resource
#	Expected value: Number of towers that have that tag 
var list: Dictionary = {}


func add_tower(tower: Tower) -> void:
	print(tower.Name)
	if not list.has(tower.Name):
		list[tower.Name] = {}
	for tag in tower.tags:
		add_tag(tower, tag)


func add_tag(tower: Tower, new_tag: Tag) -> void:
	if not list.has(tower.Name):
		print("Tower not found")
		return
	var tag_dict = list[tower.Name]
	if not tag_dict.has(new_tag):
		tag_dict[new_tag] = 1
	else:
		tag_dict[new_tag] += 1

# Used by shop to determine if item is acceptable for a tower
func tags_match(item: ItemData) -> bool:
	for tower in list:
		var tag_check = true
		if item.tags.size() < 1:
			tag_check = false
		for tag in item.tags:
			if not list[tower].has(tag):
				tag_check = false
		if tag_check:
			return true
	return false

# used by item to determine which towers it is good for
func matches(item: ItemData) -> Array:
	var arr = []
	for tower in list:
		var valid = true
		if item.tags.size() < 1:
			valid = false
		for tag in item.tags:
			if not list[tower].has(tag):
				valid = false
		if valid:
			arr.append(tower)
	return arr


func remove_tag(tower: Tower, tag: Tag) -> void:
	var tower_tags = list[tower.Name]
	if not tower_tags:
		print("Tower not found")
		return
	var count = tower_tags[tag]
	if not count:
		print("Tag not found in the tower's dictonary")
		return
	count -= 1
	if count == 0:
		tower_tags.erase(tag)
