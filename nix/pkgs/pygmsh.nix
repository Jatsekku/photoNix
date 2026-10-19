{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,

  gmsh,
  meshio,
  numpy
}:

buildPythonPackage rec {
  pname = "pygmsh";
  version = "7.1.7";
  pyproject = true;

  pythonRelaxDeps = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LLA7eqIb45rPPH8H+GHCOYFvGkrYVWVOGvntf6qiBFg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gmsh
    meshio
    numpy
  ];

}
