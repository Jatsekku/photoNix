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
              # Apply overlays defined by flake itself
              overlays = [ self.overlays.default ];
            };
            inherit system;
          }
        );
    in
    {
      # Generate devShell for each system
      devShells = forEachSupportedSystem ({ pkgs, ... }: import ./nix/devshell.nix { inherit pkgs; });

      # Set formatter for Nix
      formatter = forEachSupportedSystem ({ pkgs, ... }: pkgs.nixfmt-tree);

      # Inject packages via overlays
      overlays.default = final: prev: {
        inherit (self.packages.${final.system})
          scikit-fem
          gplugins
          pyroots
          tidy3d
          ;
      };

      # Provide packages
      packages = forEachSupportedSystem (
        { pkgs, system }: rec {
          scikit-fem = pkgs.python3Packages.callPackage ./nix/pkgs/scikit-fem.nix { };
          gplugins = pkgs.python3Packages.callPackage ./nix/pkgs/gplugins.nix { };
          pyroots = pkgs.python3Packages.callPackage ./nix/pkgs/pyroots.nix { };
          tidy3d = pkgs.python3Packages.callPackage ./nix/pkgs/tidy3d.nix { inherit pyroots; };
        }
      );
    };
}
