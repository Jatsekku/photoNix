{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  numpy,
  scipy,
}:

buildPythonPackage rec {
  pname = "scikit_fem";
  version = "12.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Cjh2TNuTQRxamURRwiwdoHgI66v5IPRixiU/ePVwP4o=";
  };

  build-system = [ flit-core ];

  dependencies = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "skfem" ];
}
