sub init()
    m.content_grid = m.top.FindNode("content_grid")
    m.header = m.top.FindNode("header")
end sub

sub onFeedChanged(obj)
    feed = obj.getData()
    m.header.text = feed.title
    postercontent = createObject("roSGNode","ContentNode")
    for each item in feed.items
		node = createObject("roSGNode","ContentNode")
	    node.streamformat = item.streamformat
	    node.title = item.title
	    node.url = item.url
	    node.description = item.description
	    node.HDGRIDPOSTERURL = item.thumbnail
	    node.SHORTDESCRIPTIONLINE1 = item.title
		node.SHORTDESCRIPTIONLINE2 = item.description
	    postercontent.appendChild(node)
    end for
    showpostergrid(postercontent)
end sub

sub showpostergrid(content)
  m.content_grid.content=content
  m.content_grid.visible=true
  m.content_grid.setFocus(true)
end sub
