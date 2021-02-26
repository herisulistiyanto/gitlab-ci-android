FROM ubuntu:20.04
MAINTAINER heri <kid.brotherhood@gmail.com>

ENV SDK_TOOLS_VERSION "6858069"

ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools"
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

RUN curl -s https://dl.google.com/android/repository/commandlinetools-linux${SDK_TOOLS_VERSION}_latest.zip > /tools.zip && \
    mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    unzip /tools.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm -v /tools.zip

RUN mkdir -p $ANDROID_HOME/licenses/ && \
    echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e\n24333f8a63b6825ea9c5514f83c2829b004d1fee" > $ANDROID_HOME/licenses/android-sdk-license && \
    echo "84831b9409646a918e30573bab4c9c91346d8abd\n504667f4c0de7af1a06de9f4b1727b84351f2910" > $ANDROID_HOME/licenses/android-sdk-preview-license && \
    yes | sdkmanager --licenses >/dev/null

RUN mkdir -p /root/.android \
    && touch /root/.android/repositories.cfg \
    && sdkmanager --update

ADD pkg.txt /sdk

RUN sdkmanager --package_file=/sdk/pkg.txt
