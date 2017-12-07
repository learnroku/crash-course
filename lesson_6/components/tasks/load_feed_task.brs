


sub init()
  m.top.functionname = "request"
  m.top.response = ""
end sub

function request()
    url = m.top.url
    http = createObject("roUrlTransfer")
    http.RetainBodyOnError(true)
    port = createObject("roMessagePort")
    http.setPort(port)
    http.setCertificatesFile("common:/certs/ca-bundle.crt")
    http.InitClientCertificates()
    http.enablehostverification(false)
    http.enablepeerverification(false)
    http.setUrl(url)
    if http.AsyncGetToString() Then
      msg = wait(10000, port)
      if (type(msg) = "roUrlEvent")
        if (msg.getresponsecode() > 0 and  msg.getresponsecode() < 400)
          m.top.response = msg.getstring()
        else
          ? "feed load failed: "; msg.getfailurereason();" "; msg.getresponsecode();" "; m.top.url
          m.top.response = ""
        end if
        http.asynccancel()
      else if (msg = invalid)
        ? "feed load failed."
        m.top.response =""
        http.asynccancel()
      end if
    end if
    return 0
end function
