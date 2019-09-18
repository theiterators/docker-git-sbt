FROM docker:18.09.6-git

ENV SBT_VERSION 1.1.5

ENV SCALA_VERSION 2.12.4

ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=212 \
    JAVA_VERSION_BUILD=04 

RUN apk add --no-cache --virtual=build-dependencies curl && \
    curl -sL "https://piccolo.link/sbt-${SBT_VERSION}.tgz" | gunzip | tar -x -C /usr/local && \
    ln -s /usr/local/sbt/bin/sbt /usr/local/bin/sbt && \
    chmod 0755 /usr/local/bin/sbt && \
    apk del build-dependencies

RUN apk add --no-cache bash openjdk${JAVA_VERSION_MAJOR}-jre=${JAVA_VERSION_MAJOR}.${JAVA_VERSION_MINOR}.${JAVA_VERSION_BUILD}

RUN \
  sbt sbtVersion && \
  mkdir precompile && cd precompile && \
  mkdir -p project && \
  echo "scalaVersion := \"${SCALA_VERSION}\"" > build.sbt && \
  echo "sbt.version=${SBT_VERSION}" > project/build.properties && \
  echo "case object Temp" > Temp.scala && \
  sbt compile && \
  cd .. && rm -rf precompile
