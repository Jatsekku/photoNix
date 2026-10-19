FROM ubuntu:24.04

# Base 
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \ 
    libgit2-dev

# Install KLayout and plugins
COPY /scripts/klayout.sh /tmp/scripts/
RUN /tmp/scripts/klayout.sh

# Install lumerical
COPY /scripts/lumerical.sh /tmp/scripts/
RUN --mount=type=bind,from=secrets,target=/tmp/secrets,rw=false \
    /tmp/scripts/lumerical.sh
ENV LUMAPIPATH="/opt/lumerical/current/api/python"
ENV PATH="/opt/lumerical/current/bin:$PATH"
ENV PYTHONPATH="$LUMAPIPATH:$PYTHONPATH"

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
ENV PATH="/root/.local/bin:$PATH"

# Install jupyter
#uv run --with jupyter jupyter lab
COPY /scripts/jupyter.sh /tmp/scripts/
RUN /tmp/scripts/jupyter.sh

