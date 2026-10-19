FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends\
    git \
    libglu1-mesa \
    libxcursor1 \
    libxft2 \
    libxinerama1 \
    libgomp1 \
    python3-tk \
    python3-pip

# Install uv
ENV UV_PROJECT_ENVIRONMENT="/opt/.venv" \
    PATH="/opt/.venv/bin:$PATH"
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy scripts into cointainer
COPY /scripts/ /scripts/

# Install KLayout and plugins
ENV KLAYOUT_PYTHONPATH="/opt/.venv/lib/python3.14/site-packages" \
    KLAYOUT_HOME="/.klayout"
RUN /scripts/klayout.sh

# Install python packages
RUN --mount=type=cache,target=/root/.cache/uv \
    uv venv /opt/.venv \
    && uv pip install \
        requests \
        numpy \
        scipy \
        pyparsing \
        matplotlib \
        requests \
        jupyterlab \
        gdsfactory \
        gplugins \
        tidy3d \
        ubcpdk \
        photonforge \
        siepic_forge \
    && chmod -R 777 /opt/.venv

