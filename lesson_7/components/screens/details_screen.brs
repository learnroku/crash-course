


sub init()
  m.title = m.top.FindNode("title")
  m.description = m.top.FindNode("description")
  m.thumbnail = m.top.FindNode("thumbnail")
  m.play_button = m.top.FindNode("play_button")
  m.top.observeField("visible", "onVisibleChange")
  m.play_button.setFocus(true)
end sub

' set proper focus to rowList in case if return from Details Screen
sub onVisibleChange()
  if m.top.visible = true then
    m.play_button.setFocus(true)
  end if
end sub

sub OnContentChange(obj)
  item = obj.getData()
  m.title.text = item.title
  m.description.text = item.description
  m.thumbnail.uri = item.HDGRIDPOSTERURL
end sub
