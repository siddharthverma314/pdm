{
  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    pypi-deps-db = {
      url = "github:DavHau/pypi-deps-db";
      flake = false;
    };
    mach-nix = {
      url = github:DavHau/mach-nix;
      inputs.pypi-deps-db.follows = "/pypi-deps-db";
      inputs.flake-utils.follows = "/flake-utils";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
  };
  outputs = { flake-utils, nixpkgs, mach-nix, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        pyproject = builtins.fromTOML (builtins.readFile ./pyproject.toml);
        package = mach-nix.lib.${system}.buildPythonApplication {
          pname = pyproject.project.name;
          version = "1.12.1";
          python = "python39";
          src = ./.;
          requirements = builtins.concatStringsSep "\n" pyproject.project.dependencies;
        };
      in
      {
        devShell = with pkgs; mkShell {
          packages = [
            rnix-lsp
          ];
        };
        defaultPackage = package;
      }
    );
}
