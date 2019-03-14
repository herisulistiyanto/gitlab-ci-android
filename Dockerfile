FROM ubuntu:18.04
MAINTAINER heri <kid.brotherhood@gmail.com>

ENV SDK_TOOLS_VERSION "4333796"
ENV VERSION_COMPILE_VERSION 28

ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools"
ENV DEBIAN_FRONTEND noninteractive


RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
    bzip2 \
    curl \
    git-core \
    html2text \
    openjdk-8-jdk \
    libc6-i386 \
    lib32stdc++6 \
    lib32gcc1 \
    lib32ncurses5 \
    lib32z1 \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN curl -s https://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS_VERSION}.zip > /tools.zip && \
    unzip -qq /tools.zip -d /sdk && \
    rm -v /tools.zip

RUN mkdir -p $ANDROID_HOME/licenses/ \
  && echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > $ANDROID_HOME/licenses/android-sdk-license \
  && echo "84831b9409646a918e30573bab4c9c91346d8abd" > $ANDROID_HOME/licenses/android-sdk-preview-license

RUN yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-28"

ADD pkg.txt /sdk
RUN mkdir -p /root/.android \
    && touch /root/.android/repositories.cfg \
    && ${ANDROID_HOME}/tools/bin/sdkmanager --update

RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses

RUN while read -r pkg; do PKGS="${PKGS}${pkg} "; done < /sdk/pkg.txt && \
    ${ANDROID_HOME}/tools/bin/sdkmanager ${PKGS}
