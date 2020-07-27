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

FROM cuda:11.0-runtime-centos8

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'

LABEL       author="Bud Gidiere" maintainer="bgidiere"

RUN yum install -y tzdata openssl curl ca-certificates fontconfig gzip tar git tar sqlite \
    && yum update -y; yum clean all

ENV JAVA_VERSION jdk-14.0.2+12_openj9-0.21.0

COPY slim-java* /usr/local/bin/

RUN set -eux; \
    ARCH="$(uname -m)"; \
    ESUM='ccfc3ad03d168fc8c097f8e3947d865e6f7f1acfc63c0ded67eac091c83699c5'; \
    BINARY_URL='https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.2%2B12_openj9-0.21.0/OpenJDK14U-jdk_x64_linux_openj9_linuxXL_14.0.2_12_openj9-0.21.0.tar.gz'; \      
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
