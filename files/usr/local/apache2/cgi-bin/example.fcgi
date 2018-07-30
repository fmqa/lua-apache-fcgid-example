#!/usr/bin/lua5.3
local fcgi = require( "fcgi" )

while fcgi.accept() do
	fcgi.print( "Content-Type: text/event-stream; charset=utf-8\r\n\r\n" )
	for i=1,10 do
		fcgi.print( "data:" .. tostring(i) .. "\n\n" )
		fcgi.flush()
        os.execute("sleep 1")
	end
	fcgi.finish()
end
