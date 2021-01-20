FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    libgtk-3-dev \
    git \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove

# INSTALL OPENCV
WORKDIR /opt
RUN git clone https://github.com/opencv/opencv.git
RUN cd opencv &&\
    git checkout 4.5.1 &&\
    mkdir -p build && \
    cd build && \
    cmake .. &&\
    make -j$(nproc) &&\
    make install

# COMPILE APPLICATION
COPY . /app
WORKDIR /app/build
RUN cmake .. &&\
    make -j$(nproc)

# COMPILE IF THERE ARE CHANGES AND RUN APPLICATION
CMD ["bash", "-c", "make -j$(nproc) && ./traffic_simulation"]