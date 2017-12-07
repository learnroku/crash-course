# INGORE THIS PAGE
-----------------
	FOR LATER:
  ```
  sub main()
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
```
  During the lifetime of the application, this loop is running and monitoring the messages for an `roSGScreenEvent` event that indicates the screen was closed. Only then will the application exit because the main() function returns.
