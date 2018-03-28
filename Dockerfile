FROM ubuntu:16.04

MAINTAINER Seungkyu Ahn <seungkyua@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
         python-dev \
         build-essential \    
         wget \
         bzip2 \
         ca-certificates \
         locales \
         python-pip \
         fonts-liberation  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

#RUN pip install --upgrade tensorflow
RUN pip install --upgrade pip setuptools
RUN pip install ipykernel \
                ipython \
                matplotlib \
                jupyter

RUN jupyter notebook --generate-config

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888
CMD ["jupyter", "notebook", "--allow-root" "--ip", "0.0.0.0"]

