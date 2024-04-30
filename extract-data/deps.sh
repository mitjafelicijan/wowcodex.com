#!/bin/sh

MYSQL_INC=$(find /usr -name mysql.h 2>/dev/null | head -n 1 | sed 's:/mysql.h::')

luarocks install etlua --local
luarocks install luafilesystem --local
luarocks install lunajson --local
luarocks install luasql-mysql MYSQL_INCDIR=$MYSQL_INC --local
