prog :=xnixperms

rebuild:
	bin/nixos-rebuild
	bin/home-manager-rebuild

nixos-rebuild:
	bin/nixos-rebuild

darwin-rebuild:
	bin/darwin-rebuild

home-manager-rebuild:
	bin/home-manager-rebuild
