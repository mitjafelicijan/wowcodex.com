default:
	@echo "Check targets!"

install:
	@echo "Installing LuaRocks packages from packages.txt"
	@while read -r package; do \
		luarocks install --local "$$package"; \
	done < packages.txt

server:
	cp -Rf assets public
	cd public && npx --yes browser-sync start --server --watch --no-open --directory
	# cp templates/index.html public/
	# cd public && python3 -m http.server 6969
