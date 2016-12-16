FROM ubuntu:trusty
MAINTAINER Ivan Gotovchits <ivg@ieee.org>
RUN apt-get -y update && apt-get -y install \
    build-essential \
    curl \
    git \
    libx11-dev \
    m4 \
    pkg-config \
    python-pip \
    software-properties-common \
    sudo \
    unzip \
    wget
RUN add-apt-repository --yes ppa:avsm/ppa && apt-get update && apt-get -y install \
    ocaml \
    ocaml-native-compilers \
    opam
RUN useradd -m bap && echo "bap:bap" | chpasswd && adduser bap sudo
RUN sed -i.bkp -e \
    's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
    /etc/sudoers
USER bap
WORKDIR /home/bap
RUN opam init --auto-setup --comp=4.02.3 --yes
RUN opam repo add bap git://github.com/BinaryAnalysisPlatform/opam-repository
RUN opam update
RUN opam depext --install bap --yes
RUN sudo pip install bap
RUN sudo cp /bin/ls /usr/bin/find-ida.sh
RUN sudo cp /bin/true /usr/bin/idaq64
RUN sudo apt-get install -y locate
RUN sudo mkdir -p /usr/bin/plugins
RUN sudo mkdir -p /usr/bin/cfg
RUN sudo chown -R bap:bap /usr/bin/plugins
RUN sudo chown -R bap:bap /usr/bin/cfg
RUN opam install -y bap-ida-python
RUN opam install -y bap-ida-plugin
ENTRYPOINT ["opam", "config", "exec", "--"]
