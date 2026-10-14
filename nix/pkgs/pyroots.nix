{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pyroots";
  version = "0.5.0";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dvPFXCDYwqiOG6rvkShUIGoN2PvMJxXubtCmRoYMLPA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api \
    --replace "poetry>=" "poetry-core>="
  '';

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "pyroots" ];
}
