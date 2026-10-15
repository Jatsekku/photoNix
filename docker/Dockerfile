FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive \
    KLAYOUT_PYTHONPATH="/workspace/.venv/lib/python3.14/site-packages" \
    KLAYOUT_HOME="/workspace/.klayout" \
    PATH="/workspace/.venv/bin:$PATH"

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy scripts into cointainer
COPY /scripts/ /scripts/
COPY ./pyproject.toml /workspace/

RUN apt-get update && apt-get install -y --no-install-recommends\
    libglu1-mesa \
    libxcursor1 \
    libxft2 \
    libxinerama1 \
    libgomp1 \
    python3-tk \
    && /scripts/klayout.sh install \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

ENTRYPOINT ["/scripts/docker-entrypoint.sh"]

