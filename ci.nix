{ sources ? import ./nix/sources.nix }:

let
  pkgs = import sources.nixpkgs { };
  gitignoreSource =
    (import sources."gitignore.nix" { inherit (pkgs) lib; }).gitignoreSource;
  pre-commit-hooks = import sources."pre-commit-hooks.nix";
  src = gitignoreSource ./.;
in
{
  inherit pkgs src;

  pre-commit-check = pre-commit-hooks.run {
    inherit src;
    hooks = {
      shellcheck.enable = true;
      nixpkgs-fmt.enable = true;
      nix-linter.enable = true;
    };
    excludes = [ "^nix/sources.nix$" ];
  };
}
