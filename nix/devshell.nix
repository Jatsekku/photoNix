{ pkgs }:
let
  pythonEnv = pkgs.python3.withPackages (ps: [
    pkgs.tidy3d
    ps.gdstk
    ps.gdsfactory
    ps.klayout
  ]);
in
{
  default = pkgs.mkShell {
    env = {
      KLAYOUT_HOME = "./.klayout";
    };
    # Nix packages provided in environment
    buildInputs = with pkgs; [
      pythonEnv
      pkgs.klayout
    ];
  };
}
