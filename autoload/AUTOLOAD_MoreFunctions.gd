extends Node


#Like clamp, but if the value is less then the miniumum, it will be set to the maximum, and vice versa
func clamp_wrap(value : Variant, minimum : Variant, maximum : Variant) -> Variant:
	if value < minimum:
		return maximum
	elif value > maximum:
		return minimum
	else:
		return value
		
		
#Randomly choose an element of an array, with an option for excluding a value
func choose(array : Array, exclude := false, excludewhat : Variant = null) -> Variant:
	randomize()
	if !exclude:
		return array[randi() % array.size()]
	if exclude:
		var returnvar : Variant = excludewhat
		while returnvar == excludewhat:
			returnvar = array[randi() % array.size()]
		return array[returnvar]
		
	#Fallback
	return array[0]


#Parse tagged text out of a string
#Tags are defined as <tag>Text</tag>
func get_tagged_text(tag : String, parse_text : String) -> String:
	var start_tag := "<"+tag+">"
	var end_tag := "</"+tag+">"
	
	var start_index := parse_text.find(start_tag) + start_tag.length()
	var end_index := parse_text.find(end_tag)
	var substr_length := end_index - start_index
	
	return parse_text.substr(start_index, substr_length)
	
	
#Return a lowercase version of a given string. Mainly used as a helper class for dialogue
func lower(string : String) -> String:
	return string.to_lower()


#Check if a node is in any of the given groups
func match_group(node : Node, groups : Array[StringName]) -> bool:
	for group in groups:
		if node.is_in_group(group):
			return true
	return false
