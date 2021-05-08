{
  description = "dev env mariadb python connector";

  inputs.nixpkgs.url = "github:NixOs/nixpkgs/nixos-20.09";
  inputs.nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-compat, ... }@inputs:
  {
    overlay = final: prev:
      let
        pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system};
        pkgs = inputs.nixpkgs.legacyPackages.${prev.system};
      in {
        # define packages with `package = `
        dev-env = pkgs.mkShell {
          inputsFrom = with pkgs; [
            python3
          ];
          buildInputs = with pkgs; [
            gcc
            libmysqlclient
          ];
        };
      };
    } // inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          overlays = [ self.overlay ];
          inherit system;
        };
      in {
        defaultPackage = pkgs.dev-env;
        devShell = pkgs.dev-env;
      }
    );
}
