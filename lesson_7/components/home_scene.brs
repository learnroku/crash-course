function init()
	? "[home_scene] init"
	m.category_screen = m.top.findNode("category_screen")
	m.content_screen = m.top.findNode("content_screen")
	m.details_screen = m.top.findNode("details_screen")
	m.error_dialog = m.top.findNode("error_dialog")
	m.videoplayer = m.top.findNode("videoplayer")
	initializeVideoPlayer()

	m.category_screen.observeField("category_selected", "onCategorySelected")
	m.content_screen.observeField("content_selected", "onContentSelected")
	m.details_screen.observeField("play_button_pressed", "onPlayButtonPressed")

	m.category_screen.setFocus(true)
	loadConfig()
end function

sub initializeVideoPlayer()
	m.videoplayer.EnableCookies()
	m.videoplayer.setCertificatesFile("common:/certs/ca-bundle.crt")
	m.videoplayer.InitClientCertificates()
	'set position notification to 1 second
	m.videoplayer.notificationInterval=1
	m.videoplayer.observeFieldScoped("position", "onPlayerPositionChanged")
	m.videoplayer.observeFieldScoped("state", "onPlayerStateChanged")
end sub

sub loadConfig()
    m.config_task = createObject("roSGNode", "load_config_task")
    m.config_task.observeField("filedata", "onConfigResponse")
    m.config_task.observeField("error", "onConfigError")
    m.config_task.filepath = "resources/config.json"
    m.config_task.control="RUN"
end sub

sub onConfigResponse(obj)
	params = {config:obj.getData()}
	m.category_screen.callFunc("updateConfig",params)
	m.content_screen.callFunc("updateConfig",params)
end sub

sub onConfigError(obj)
	showErrorDialog(obj.getData())
end sub

sub onCategorySelected(obj)
  ' note that you do NOT get the content node you want, just an index.
  selected_index = obj.getData()
  'notice how these are the same value?
  ? "selected_index :";selected_index
  ? "checkedItem: ";m.category_screen.findNode("category_list").checkedItem
  ' look up the index using this verbose, dumb technique.
	' store the category to display info in an error scenario.'
   m.selected_category = m.category_screen.findNode("category_list").content.getChild(selected_index)
   'there are a thousand differents ways to do what comes next...'
   loadFeed(m.selected_category.feed_url)
end sub

sub onContentSelected(obj)
  ' note that you do NOT get the content node you want, just an index.
  selected_index = obj.getData()
  ' look up the media item using this verbose, dumb technique.
   m.selected_media = m.content_screen.findNode("content_grid").content.getChild(selected_index)
	 m.details_screen.content = m.selected_media
	 m.content_screen.visible = false
	 m.details_screen.visible = true
end sub

sub onPlayButtonPressed(obj)
	? "PLAY!!!",m.selected_media
	m.details_screen.visible = false
	m.videoplayer.visible = true
	m.videoplayer.setFocus(true)
	m.videoplayer.content = m.selected_media
	m.videoplayer.control = "play"
end sub

sub loadFeed(url)
	m.feed_task = createObject("roSGNode", "load_feed_task")
	m.feed_task.observeField("response", "onFeedResponse")
	m.feed_task.observeField("error", "onFeedError")
	m.feed_task.url = url
	m.feed_task.control = "RUN"
end sub

sub onFeedResponse(obj)
	response = obj.getData() 'this is a string from the http response
	'turn the string (JSON) into an Associative Array
	data = parseJSON(response)
	if data <> invalid and data.items <> invalid
		'hide the category_screen, show the content_screen
		m.category_screen.visible = false
		m.content_screen.visible = true
		' assign data to content screen
		m.content_screen.feed_data = data
	else
		showErrorDialog("Feed data malformed.")
	end if
end sub

sub onFeedError(obj)
	showErrorDialog(obj.getData())
end sub

sub onPlayerStateChanged(obj)
  state = obj.getData()
	? "onPlayerStateChanged: ";state
	if state="error"
    	showErrorDialog(m.videoplayer.errorMsg+ chr(10) + "Error Code: "+m.videoplayer.errorCode.toStr())
	else if state = "finished"
		closeVideo()
	end if
end sub

sub closeVideo()
	m.videoplayer.control = "stop"
	m.videoplayer.visible=false
	m.details_screen.visible=true
end sub

sub showErrorDialog(message)
	m.error_dialog.title = "ERROR"
	m.error_dialog.message = message
	m.error_dialog.visible=true
	'tell the home scene to own the dialog so the remote behaves'
	m.top.dialog = m.error_dialog
end sub

' Main Remote keypress handler
function onKeyEvent(key, press) as Boolean
	? "[home_scene] onKeyEvent", key, press
	' we must capture the 'true' for press, it comes first (true=down,false=up) to keep the firmware from handling the event
	if key = "back" and press
		if m.content_screen.visible
			m.content_screen.visible=false
			m.category_screen.visible=true
			return true
		else if m.details_screen.visible
			m.details_screen.visible=false
			m.content_screen.visible=true
			return true
		else if m.videoplayer.visible
			closeVideo()
			return true
		end if
	end if
  return false
end function
