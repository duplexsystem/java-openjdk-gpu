# ------------------------------------------------------------------------------
#               NOTE: THIS DOCKERFILE IS GENERATED VIA "build_latest.sh" or "update_multiarch.sh"
#
#                       PLEASE DO NOT EDIT IT DIRECTLY.
# ------------------------------------------------------------------------------
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM centos:latest

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'

RUN yum install -y tzdata openssl curl ca-certificates fontconfig gzip tar git tar sqlite iproute2 cuda-libraries-11-0-11.0.2-1 cuda-nvtx-11-0-11.0.167-1 libnpp-11-0-11.1.0.218-1 libcublas-11-0-11.1.0.229-1 libnccl-2.7.6-1+cuda11.0 \
    && yum update -y; yum clean all

ENV JAVA_VERSION jdk-14.0.2+12_openj9-0.21.0

ENV NCCL_VERSION 2.7.6

COPY slim-java* /usr/local/bin/

RUN set -eux; \
    ARCH="$(uname -m)"; \
    case "${ARCH}" in \
       ppc64el|ppc64le) \
         ESUM='d758ea2d0916ce8fbcf07af65509701c97f20324cd3632ef1c1ca10568dbede4'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.2%2B12_openj9-0.21.0/OpenJDK14U-jdk_ppc64le_linux_openj9_linuxXL_14.0.2_12_openj9-0.21.0.tar.gz'; \
         ;; \
       s390x) \
         ESUM='1bf8e25f8ff6095128c670992df553e5e7752b799ba8a638ca938c744b7157fa'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.2%2B12_openj9-0.21.0/OpenJDK14U-jdk_s390x_linux_openj9_linuxXL_14.0.2_12_openj9-0.21.0.tar.gz'; \
		 ;; \
       amd64|x86_64) \
         ESUM='ccfc3ad03d168fc8c097f8e3947d865e6f7f1acfc63c0ded67eac091c83699c5'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.2%2B12_openj9-0.21.0/OpenJDK14U-jdk_x64_linux_openj9_linuxXL_14.0.2_12_openj9-0.21.0.tar.gz'; \      
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz; \ 
    rm -rf /var/cache/yum/*; \
    adduser container;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

USER container
ENV  USER=container HOME=/home/container

USER        container
ENV         USER=container HOME=/home/container

WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]
