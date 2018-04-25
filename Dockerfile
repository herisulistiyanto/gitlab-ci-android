FROM ubuntu:16.04
MAINTAINER heri

ENV VERSION_SDK_TOOLS "27.0.3"
ENV VERSION_BUILD_TOOLS "27.0.3"
ENV VERSION_TARGET_SDK "27"
ENV VERSION_SDK_TOOLS_LINUX "3859397"

ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools"
ENV DEBIAN_FRONTEND noninteractive

# Accept License
RUN mkdir -p $ANDROID_HOME/licenses/ \
  && echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > $ANDROID_HOME/licenses/android-sdk-license \
  && echo "84831b9409646a918e30573bab4c9c91346d8abd\n504667f4c0de7af1a06de9f4b1727b84351f2910" > $ANDROID_HOME/licenses/android-sdk-preview-license

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
      unzip \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN curl -s https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS_LINUX}.zip > /sdk.zip && \
    unzip /sdk.zip -d /sdk && \
    rm -v /sdk.zip

RUN mkdir /sdk/tools/keymaps && \
    touch /sdk/tools/keymaps/en-us


RUN (while [ 1 ]; do sleep 5; echo y; done) | ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;27.0.3" "platforms;android-${VERSION_TARGET_SDK}" "add-ons;addon-google_apis-google-24" "platform-tools" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository" "system-images;android-${VERSION_TARGET_SDK};google_apis_playstore;x86" "system-images;android-${VERSION_TARGET_SDK};google_apis;x86"
