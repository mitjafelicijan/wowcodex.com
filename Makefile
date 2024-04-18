default:
	@echo "Check targets!"

install:
	@echo "Installing LuaRocks packages from packages.txt"
	@while read -r package; do \
		luarocks install --local "$$package"; \
	done < packages.txt

build:
	cp -Rf assets public
	cp templates/index.html public/
	cd apiref && lua apirefgen.lua

server: build
	cd public && npx --yes browser-sync start --server --watch --no-open --directory
	# cd public && python3 -m http.server 6969
