FROM frolvlad/alpine-glibc
LABEL author="Alexandre Hamelin <alexandre.hamelin gmail.com>" \
      copyright="Copyright (c) 2017, Alexandre Hamelin <alexandre.hamelin gmail.com>" \
      license="MIT"

# Use --build-arg version=<version> to build a new image for a different version.
ARG version
ENV version ${version:-1.5.1-621}
ENV PATH $PATH:/opt/bento4/bin:/opt/bento4/utils

# TODO: python2 requires 50MB+, could it be replaced with a much simpler custom script?
RUN apk -q --no-cache add libstdc++ python2

WORKDIR /opt
RUN wget -q http://zebulon.bok.net/Bento4/binaries/Bento4-SDK-${version//./-}.x86_64-unknown-linux.zip && \
    unzip *.zip >/dev/null && rm -f *.zip
RUN ln -s Bento4-SDK* bento4
RUN sed -i -e 's/bash/sh/' /opt/bento4/bin/mp4dash
RUN sed -i -e "s/sample_desc\['width'\]/sample_desc.get('width', 0)/; s/sample_desc\['height'\]/sample_desc.get('height', 0)/" /opt/bento4/utils/mp4utils.py

WORKDIR /mnt
VOLUME /mnt
