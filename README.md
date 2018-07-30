# lua-apache-fcgid-example
Lua 5.3 + fastcgi + Docker example 

## Synopsis

Build it:

    $ docker build -t luafcgi .

Try it:

    $ docker run --rm -d --name fcgi -t -i -p 8080:80 luafcgi
    $ curl --verbose localhost:8080/cgi-bin/example.fcgi
    *   Trying 127.0.0.1...
    * TCP_NODELAY set
    * Connected to localhost (127.0.0.1) port 8080 (#0)
    > GET /cgi-bin/example.fcgi HTTP/1.1
    > Host: localhost:8080
    > User-Agent: curl/7.58.0
    > Accept: */*
    >
    < HTTP/1.1 200 OK
    < Date: Mon, 30 Jul 2018 00:52:11 GMT
    < Server: Apache/2.4.34 (Unix) mod_fcgid/2.3.9
    < Transfer-Encoding: chunked
    < Content-Type: text/event-stream; charset=utf-8
    <
    data:1
    
    data:2
    
    data:3
    
    data:4
    
    data:5
    
    data:6
    
    data:7
    
    data:8
    
    data:9
    
    data:10
    
    * Connection #0 to host localhost left intact
