FROM alpine:3.7 AS build

ENV LUA_VERSION 5.3
ENV LUA_PACKAGE lua${LUA_VERSION}
ENV LUA_LUAROCKS_VERSION 3.0.0
ENV LUA_LUAROCKS https://github.com/luarocks/luarocks/archive/v${LUA_LUAROCKS_VERSION}.tar.gz
ENV LUA_FCGI https://raw.githubusercontent.com/kochab/lua-fcgi/mod/rockspec/fcgi-scm-1.rockspec

RUN apk update
RUN apk add ${LUA_PACKAGE} ${LUA_PACKAGE}-dev wget make gcc musl-dev fcgi-dev outils-md5 git

RUN wget -qO- ${LUA_LUAROCKS} | tar zxvf - && \
    cd luarocks-${LUA_LUAROCKS_VERSION} && \
    ./configure && \
    make install && \
    echo 'variables.LUA_LIBDIR = "/usr/lua5.3/lib"' >> /usr/local/etc/luarocks/config-5.3.lua

RUN luarocks install ${LUA_FCGI}

FROM httpd:alpine AS mod

ENV MOD_FCGI_VERSION 2.3.9
ENV MOD_FCGI http://mirror.softaculous.com/apache/httpd/mod_fcgid/mod_fcgid-${MOD_FCGI_VERSION}.tar.gz

RUN apk add gcc musl-dev make
RUN cd /tmp && \
    wget -qO- ${MOD_FCGI} | tar zxvf - && \
    cd mod_fcgid-${MOD_FCGI_VERSION} && \
    ./configure.apxs && \
    make install

FROM httpd:alpine

ENV LUA_VERSION 5.3
ENV LUA_PACKAGE lua${LUA_VERSION}

RUN apk add ${LUA_PACKAGE} fcgi

COPY --from=build /usr/local/lib/lua /usr/local/lib/lua
COPY --from=mod /usr/local/apache2/modules/mod_fcgid.so /usr/local/apache2/modules
COPY --from=mod /usr/local/apache2/manual/mod/mod_fcgid* /usr/local/apache2/manual/mod/
COPY --from=mod /usr/local/apache2/conf/httpd.conf /usr/local/apache2/conf
COPY --from=mod /usr/local/apache2/conf/original/httpd.conf /usr/local/apache2/conf/original

COPY files/ /
