{
  description = "Photonic design/simulation for Nix";

  # Flake inputs
  inputs = {
    # Nix Packages collection & NixOS.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    inputs@{ self, ... }:
    let
      # List of all supported systems
      supportedSystems = inputs.nixpkgs.lib.systems.flakeExposed;

      # Function for providing system-specific attributes
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            # Nixpkgs configured per system
            pkgs = import inputs.nixpkgs {
              inherit system;
            };
            inherit system;
          }
        );
    in
    {
      # Set formatter for Nix
      formatter = forEachSupportedSystem ({ pkgs, ... }: pkgs.nixfmt-tree);

      # Provide packages
      packages = forEachSupportedSystem (
        { pkgs, system }: rec {
          pyroots = pkgs.python3Packages.callPackage ./nix/pkgs/pyroots.nix { };
        }
      );
    };
}
