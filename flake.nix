{
  description = "cli";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  nixConfig.bash-prompt-suffix = "🚀";
  outputs = {
    self,
    nixpkgs,
  }: (let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    drv = pkgs.buildGoModule {
      name = "cli";
      src = ./.;
      vendorHash = null;
      nativeBuildInputs = with pkgs; [ git ];
      buildPhase = "go build -o codecrafters cmd/codecrafters/main.go";

      installPhase = ''
        mkdir -p $out/bin
        install -m755 codecrafters $out/bin
      '';
      checkPhase = null;
    };

    dev = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        helix

        go
        gopls
        delve
      ];
    };
  in
    with pkgs; {
      formatter.${system} = alejandra;
      packages.${system}.default = drv;
      devShells.${system}.default = dev;
    });
}
