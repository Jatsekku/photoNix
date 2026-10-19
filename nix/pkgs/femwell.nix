{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,

  gmsh,
  pygmsh,
  matplotlib,
  scikit-fem,
  shapely,
}:

buildPythonPackage rec {
  pname = "femwell";
  version = "0.1.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lw8UOAY6ChfvfBgUQ4NGhar49gfN4Rob3iMt5XYOuCI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pygmsh
    gmsh
    matplotlib
    scikit-fem
    shapely
  ];

}
