FROM ubuntu:18.04

RUN apt update && apt install -y \
ninja-build \
ant \
lib32stdc++6 \
lib32z1 \
wget \
libprotobuf-dev \
protobuf-compiler \
curl \
unzip

RUN wget https://cmake.org/files/v3.18/cmake-3.18.0-Linux-x86_64.sh -O /cmake.sh \
&& mkdir /opt/cmake \
&& sh /cmake.sh --prefix=/opt/cmake --skip-license \
&& ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake \
&& wget https://github.com/protocolbuffers/protobuf/releases/download/v3.13.0/protoc-3.13.0-linux-x86_64.zip -O /protoc-3.13.0-linux-x86_64.zip \
&& unzip /protoc-3.13.0-linux-x86_64.zip \
&& echo 'export ANDROID_NDK=/android-ndk-r21d/' >> /root/.bashrc \
&& echo 'export PATH=$PATH:/protoc-3.13.0-linux-x86_64/bin/' >> /root/.bashrc