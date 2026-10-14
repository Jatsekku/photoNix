{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,

  autograd,
  boto3,
  click,
  dask,
  fastmcp,
  filelock,
  h5netcdf,
  h5py,
  importlib-metadata,
  joblib,
  matplotlib,
  numpy,
  pydantic,
  pydantic-settings,
  pyjwt,
  pyroots,
  pyyaml,
  requests,
  responses,
  rich,
  shapely,
  scipy,
  toml,
  tomlkit,
  trimesh,
  xarray,
}:

buildPythonPackage rec {
  pname = "tidy3d";
  version = "2.12.0";
  pyproject = true;

  pythonRelaxDeps = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4FMwi13jDg9qrfRkHZKIEhR39d1NZYtgS6Fj2rOCSNs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    autograd
    boto3
    click
    dask
    fastmcp
    filelock
    h5netcdf
    h5py
    importlib-metadata
    joblib
    matplotlib
    numpy
    pydantic
    pydantic-settings
    pyjwt
    pyyaml
    pyroots
    requests
    responses
    rich
    scipy
    shapely
    toml
    tomlkit
    trimesh
    xarray
  ];

  doCheck = false;

}
