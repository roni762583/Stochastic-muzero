# Gemini updated

FROM python:3.10-bullseye

COPY . /app

WORKDIR /app

RUN apt-get -y update \
    && apt-get install --no-install-recommends -y \
        unzip \
        libglu1-mesa-dev \
        libgl1-mesa-dev \
        libosmesa6-dev \
        xvfb \
        patchelf \
        ffmpeg \
        cmake \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /root/.mujoco \
    && cd /root/.mujoco \
    && wget -qO- 'https://github.com/deepmind/mujoco/releases/download/2.1.0/mujoco210-linux-x86_64.tar.gz' | tar -xzvf -

# Set LD_LIBRARY_PATH before using it
ENV LD_LIBRARY_PATH=/root/.mujoco/mujoco210/bin

EXPOSE 8888

ENTRYPOINT ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--notebook-dir=/app", "--NotebookApp.default_url=tutorial.ipynb,README.md","--NotebookApp.terminals_enabled=True"]