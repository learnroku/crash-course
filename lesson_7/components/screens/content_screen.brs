sub init()
	m.content_grid = m.top.FindNode("content_grid")
	m.header = m.top.FindNode("header")
end sub

sub onFeedChanged(obj)
	feed = obj.getData()
  ? "ON Feed changed! ", feed
	m.header.text = feed.title
  postercontent = createObject("roSGNode","ContentNode")
  'find the host value in the thumbnail url, will be replaced with the m.host value
  regex = createObject("roRegEx", "http://[a-z0-9.:]+", "i")
  for each item in feed.items
    node = createObject("roSGNode","ContentNode")
    node.streamformat = item.streamformat
    node.title = item.title
    node.url = item.url
    node.description = item.description
    node.HDGRIDPOSTERURL = regex.replace(item.thumbnail,m.host)
    node.SHORTDESCRIPTIONLINE1 = item.title
    postercontent.appendChild(node)
  end for
  showpostergrid(postercontent)
end sub

sub showpostergrid(content)
	m.content_grid.content=content
	m.content_grid.visible=true
	m.content_grid.setFocus(true)
end sub

function updateConfig(params)
	m.host = params.config.host
end function
