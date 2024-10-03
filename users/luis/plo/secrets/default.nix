{
  imports = [ 
		./aws.nix
	];

	sops.gnupg.home = "/home/luis/.gnupg";
}
