


function init()
  m.category_list=m.top.findNode("category_list")
	m.category_list.setFocus(true)
	m.top.observeField("visible", "onVisibleChange")
end function

' set proper focus to rowList in case if return from Details Screen
sub onVisibleChange()
  if m.top.visible = true then
    m.category_list.setFocus(true)
  end if
end sub
