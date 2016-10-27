FROM ubuntu:16.04
MAINTAINER Matheus V. Garcez <hakandilek@gmail.com>

# Install apt packages
RUN apt-get update && apt-get install -y git lib32stdc++6 lib32z1 npm nodejs nodejs-legacy s3cmd build-essential curl openjdk-8-jdk-headless sendemail libio-socket-ssl-perl libnet-ssleay-perl && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install android SDK, tools and platforms 
RUN cd /opt && curl https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz -o android-sdk.tgz && tar xzf android-sdk.tgz && rm android-sdk.tgz
ENV ANDROID_HOME /opt/android-sdk-linux
RUN echo 'y' | /opt/android-sdk-linux/tools/android update sdk -u -a -t platform-tools,build-tools-23.0.3,android-23

# Install npm packages
RUN npm i -g cordova ionic node-gyp && npm cache clean

RUN mkdir "$ANDROID_SDK/licenses" || true
RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_SDK/licenses/android-sdk-license"
RUN echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_SDK/licenses/android-sdk-preview-license"

# Create dummy app to build and preload gradle and maven dependencies
RUN cd / && echo 'n' | ionic start app --v2 && cd /app && ionic platform add android && ionic build android && rm -rf * .??* && rm /root/.android/debug.keystore

WORKDIR /app
