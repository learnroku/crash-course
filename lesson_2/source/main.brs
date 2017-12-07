


sub main()
	screen = createObject("roSGScreen")
	scene = screen.createScene("home_scene")
  screen.Show()
  port = createObject("roMessagePort")
  screen.setMessagePort(m.port)
	'this loop is necessary to keep the application open
	'otherwise the channel will exit when it reaches the end of main()
  while(true)
		' nothing happens in here, yet
		' the HOME and BACK buttons on the remote will nuke the app
  end while
end sub
