function init()
	? "[home_scene] init"
	m.category_screen = m.top.findNode("category_screen")
	m.category_screen.setFocus(true)
end function

' Main Remote keypress handler
function onKeyEvent(key, press) as Boolean
	? "[home_scene] onKeyEvent", key, press
  return false
end function
