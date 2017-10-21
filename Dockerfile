FROM ubuntu:16.04
MAINTAINER heri

ENV VERSION_SDK_TOOLS "26.0.0"
ENV VERSION_BUILD_TOOLS "26.0.0"
ENV VERSION_TARGET_SDK "26"

ENV SDK_PACKAGES '"build-tools;${VERSION_BUILD_TOOLS}" "platforms;android-${VERSION_TARGET_SDK}" "add-ons;addon-google_apis-google-${VERSION_TARGET_SDK}" "platform-tools" "extras:extra-android-m2repository" "extras;android;m2repository" "extras;google;google_play_services" "extras:google;m2repository" "system-images;android-${VERSION_TARGET_SDK};google_apis_playstore;x86" "system-images;android-${VERSION_TARGET_SDK};google_apis;x86"'

ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools"
ENV DEBIAN_FRONTEND noninteractive

# Accept License

# Constraint Layout / [Solver for ConstraintLayout 1.0.0-alpha8, ConstraintLayout for Android 1.0.0-alpha8]
RUN mkdir -p $ANDROID_HOME/licenses/
RUN echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > $ANDROID_HOME/licenses/android-sdk-license

RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
      curl \
      html2text \
      openjdk-8-jdk \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc1 \
      lib32ncurses5 \
      lib32z1 \
      unzip \
      qtbase5-dev \
      qtdeclarative5-dev \
      wget \
      qemu-kvm \
      build-essential \
      python2.7 \
      python2.7-dev \
      yamdi \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN wget -nv https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && unzip sdk-tools-linux-3859397.zip -d /sdk && \
    rm -v sdk-tools-linux-3859397.zip

RUN wget -nv https://pypi.python.org/packages/1e/8e/40c71faa24e19dab555eeb25d6c07efbc503e98b0344f0b4c3131f59947f/vnc2flv-20100207.tar.gz && tar -zxvf vnc2flv-20100207.tar.gz && rm vnc2flv-20100207.tar.gz && \
    cd vnc2flv-20100207 && ln -s /usr/bin/python2.7 /usr/bin/python && python setup.py install

RUN mkdir /sdk/tools/keymaps && \
    touch /sdk/tools/keymaps/en-us

#RUN mkdir /helpers

#COPY wait-for-avd-boot.sh /helpers

RUN (while [ 1 ]; do sleep 5; echo y; done) | ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;26.0.0" "platforms;android-26" "add-ons;addon-google_apis-google-24" "platform-tools" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository" "system-images;android-26;google_apis_playstore;x86" "system-images;android-26;google_apis;x86"

RUN apt-get update

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]