FROM debian:wheezy

COPY apt.conf /etc/apt/apt.conf

RUN apt-get update \
 && apt-get install -y --force-yes --no-install-recommends \
      apt-transport-https \
      ssh-client \
      build-essential \
      curl \
      ca-certificates \
      git \
      libicu-dev \
      'libicu[0-9][0-9].*' \
      lsb-release \
      python-all \
      rlwrap \
      libaio1 \
      unzip \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN mkdir -p opt/oracle
ADD ./oracle/linux/ .

RUN unzip instantclient-basic-linux.x64-12.1.0.2.0.zip -d /opt/oracle \
  && unzip instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /opt/oracle  \
  && rm instantclient-basic-linux.x64-12.1.0.2.0.zip \
  && rm instantclient-sdk-linux.x64-12.1.0.2.0.zip \
  && mv /opt/oracle/instantclient_12_1 /opt/oracle/instantclient \
  && ln -s /opt/oracle/instantclient/libclntsh.so.12.1 /opt/oracle/instantclient/libclntsh.so \
  && ln -s /opt/oracle/instantclient/libocci.so.12.1 /opt/oracle/instantclient/libocci.so

ENV LD_LIBRARY_PATH="/opt/oracle/instantclient"
ENV OCI_HOME="/opt/oracle/instantclient"
ENV OCI_LIB_DIR="/opt/oracle/instantclient"
ENV OCI_INCLUDE_DIR="/opt/oracle/instantclient/sdk/include"

RUN echo '/opt/oracle/instantclient/' | tee -a /etc/ld.so.conf.d/oracle_instant_client.conf && ldconfig
