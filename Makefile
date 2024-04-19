MAKEFLAGS=-j6

default:
	@echo "Check targets!"

install:
	@echo "Installing LuaRocks packages from packages.txt"
	@while read -r package; do \
		luarocks install --local "$$package"; \
	done < packages.txt

server:
	cd public && npx --yes browser-sync start --server --watch --no-open

index.build:
	cp templates/index.html public/

apiref.dev: apiref.watch server

apiref.build:
	cp -Rf assets public
	cd apiref && lua apirefgen.lua

apiref.watch:
	find . \( -name "*.lua" -o -name "*.html" \)  -not -path "./public/*" | entr -r make apiref.build
