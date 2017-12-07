sub init()
  m.top.functionname = "load"
end sub

function load()
    if m.top.filepath = ""
        m.top.error = "Config can't be loaded because filepath not provided."
    else
	    data=ReadAsciiFile("pkg:/"+m.top.filepath)
	    ? "[Load Config Task] Data: "; data
	    json = parseJSON(data)
	    if json = invalid
	        m.top.error = "Config file contents invalid."
	    else
	        m.top.filedata = json
	    end if
	end if
end function
