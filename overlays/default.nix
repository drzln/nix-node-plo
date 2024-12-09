[
  (self: super: {
    neovim_drzln = super.callPackage ../packages/neovim { };
  })
  # (self: super: {
  #   cb = super.buildRustPackage rec {
  #     pname = "cb";
  #     version = "1.0.0"; # Replace with the actual version tag
  #
  #     # Fetch the source from GitHub
  #     src = super.fetchFromGitHub {
  #       owner = "niedzielski";
  #       repo = "cb";
  #       rev = "v1.0.0"; # Replace with the desired commit or tag
  #       sha256 = "0v..."; # Placeholder, will be updated
  #     };
  #
  #     # Specify any additional build inputs if required
  #     buildInputs = with super; [
  #       # e.g., openssl
  #     ];
  #
  #     meta = with super.lib; {
  #       description = "Description of cb tool";
  #       homepage = "https://github.com/niedzielski/cb";
  #       license = licenses.mit;
  #       maintainers = with maintainers; [ maintainers.yourName ];
  #     };
  #   };
  # })
]
