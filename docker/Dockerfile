FROM ubuntu:24.04

# Base 
ENV DEBIAN_FRONTEND=noninteractive
COPY /scripts/ /tmp/scripts/
RUN apt-get update

# Install KLayout and plugins
ENV KLAYOUT_HOME="/.klayout" 
RUN /tmp/scripts/klayout.sh

# Install lumerical
RUN --mount=type=bind,from=secrets,target=/tmp/secrets,rw=false \
    /tmp/scripts/lumerical.sh

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install python packages
# RUN --mount=type=cache,target=/root/.cache/uv \
#     uv venv /opt/.venv \
#     && uv pip install \
#         matplotlib \
#         requests \
#         jupyterlab \
#         gdsfactory \
#         gplugins \
#         tidy3d \
#         ubcpdk \
#         photonforge \
#         siepic_forge \
#     && chmod -R 777 /opt/.venv

