{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,

  gdsfactory,
  matplotlib,
  numpy,
  pint,
  pydantic,
  scipy,
  tqdm,
  xarray,
}:

buildPythonPackage rec {
  pname = "gplugins";
  version = "2.1.5";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D3JcLhFY+6G8pS7CdK//LthPLSCSizSIHanXeRdXL3Q=";
  };

  build-system = [ flit-core ];

  dependencies = [
    gdsfactory
    matplotlib
    numpy
    pint
    pydantic
    scipy
    tqdm
    xarray
  ];

  pythonImportsCheck = [ "gplugins" ];
}
