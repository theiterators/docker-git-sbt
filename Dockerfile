FROM docker:19.03.5-git

ENV SBT_VERSION 1.6.0

ENV SCALA_VERSION 2.13.7

ENV JAVA_VERSION_MAJOR=17 \
    JAVA_VERSION_MINOR=0 \
    JAVA_VERSION_BUILD=1_p12-r0

RUN apk update && apk add --no-cache --virtual=build-dependencies tar libcurl curl && \
    curl -sL "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | gunzip | tar -x -C /usr/local && \
    ln -s /usr/local/sbt/bin/sbt /usr/local/bin/sbt && \
    chmod 0755 /usr/local/bin/sbt && \
    apk del build-dependencies

RUN apk add --no-cache bash openjdk${JAVA_VERSION_MAJOR}=${JAVA_VERSION_MAJOR}.${JAVA_VERSION_MINOR}.${JAVA_VERSION_BUILD} --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

ENV JAVA_HOME=/usr/local/openjdk-17
ENV PATH="$JAVA_HOME/bin:${PATH}"

RUN apk add freetype-dev fontconfig  ttf-dejavu

RUN \
  mkdir precompile && cd precompile && \
  sbt sbtVersion && \
  mkdir -p project && \
  echo "scalaVersion := \"${SCALA_VERSION}\"" > build.sbt && \
  echo "sbt.version=${SBT_VERSION}" > project/build.properties && \
  echo "case object Temp" > Temp.scala && \
  sbt compile && \
  cd .. && rm -rf precompile
