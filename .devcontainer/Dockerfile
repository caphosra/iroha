FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PUB_CACHE=/home/codespace/.pub_cache
ENV PATH="/home/codespace/flutter/bin:$PATH"

RUN \
    apt update; \
    apt -y install git curl unzip python3 python3-pip; \
    apt autoremove -y; \
    apt clean -y; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir /home/codespace; \
    cd /home/codespace; \
    git clone https://github.com/flutter/flutter --depth 1; \
    /home/codespace/flutter/bin/flutter config --enable-web;
