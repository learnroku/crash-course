


sub main()
	' Print information from Roku manifest
	app_info = createObject("roAppInfo")
	? "App Title: ", app_info.getTitle()
	? "App Version: ", app_info.getVersion()
	? "Channel ID: ", app_info.getID()
	? "isDev: ", app_info.isDev()
	' Print information from device
	? "- - - - - - - - - - - - - - - - "
	device_info = createObject("roDeviceInfo")
	? "Model: ", device_info.getModel()
	? "Display Name: ", device_info.getModelDisplayName()
	? "Firmware: ", device_info.getVersion()
	? "Device ID: ", device_info.getDeviceUniqueId()
	? "Friendly Name: ", device_info.getFriendlyName()
	display_size = device_info.getDisplaySize()
	? "Display Size: ", display_size.w;"x";display_size.h
	? "UI Resolution: ", device_info.getUIResolution()
	? "Video Mode: ", device_info.getVideoMode()
	? "IP Address: ",device_info.getExternalIp()

	m.port = createObject("roMessagePort")
	screen = createObject("roSGScreen")
	screen.setMessagePort(m.port)
	scene = screen.createScene("home_scene")
	screen.Show()
	' this loop is necessary to keep the application open
	' otherwise the channel will exit when it reaches the end of main()
	while(true)
		msg = wait(0, m.port)
		msgType = type(msg)
		if msgType = "roSGScreenEvent"
			if msg.isScreenClosed() then return
		end if
	end while
end sub
