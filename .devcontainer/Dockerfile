FROM eclipse-temurin:26-jdk-noble AS java
FROM ghcr.io/astral-sh/uv:latest AS uv
FROM gcc:16

COPY --from=java /opt/java/openjdk /opt/java/openjdk
COPY --from=uv /uv /usr/local/bin/uv

ENV JAVA_HOME=/opt/java/openjdk
ENV UV_PYTHON_INSTALL_DIR=/opt/python
ENV UV_PYTHON_BIN_DIR=/usr/local/bin
ENV PATH="/opt/java/openjdk/bin:/usr/local/bin:${PATH}"
ENV LANG=C.UTF-8

RUN apt-get update \
    && apt-get install -y --no-install-recommends gh sudo fontconfig \
    && rm -rf /var/lib/apt/lists/* \
    && uv python install --default 3 \
    && useradd --create-home --shell /bin/bash --uid 1000 codespace \
    && printf 'codespace ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/codespace \
    && chmod 0440 /etc/sudoers.d/codespace

RUN gcc --version && g++ --version && java --version && python3 --version
