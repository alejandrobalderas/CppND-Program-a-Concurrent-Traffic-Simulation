FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    libgtk-3-dev \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove

WORKDIR /opt
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/master.zip &&\
    unzip opencv.zip && \
    mkdir -p build && \
    cd build && \
    cmake ../opencv-master &&\
    make -j$(nproc) &&\
    make install

COPY . /app
WORKDIR /app/build
RUN cmake .. &&\
    make -j$(nproc)
CMD ["bash", "-c", "make -j$(nproc) && ./traffic_simulation"]