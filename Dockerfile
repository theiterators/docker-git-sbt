FROM docker:18.09.6-git

ENV SBT_VERSION 1.1.5

ENV SCALA_VERSION 2.12.4

RUN apk add --no-cache --virtual=build-dependencies curl && \
    curl -sL "https://piccolo.link/sbt-${SBT_VERSION}.tgz" | gunzip | tar -x -C /usr/local && \
    ln -s /usr/local/sbt/bin/sbt /usr/local/bin/sbt && \
    chmod 0755 /usr/local/bin/sbt && \
    apk del build-dependencies

RUN apk add --no-cache bash openjdk8-jre

RUN \
  sbt sbtVersion && \
  mkdir precompile && cd precompile && \
  mkdir -p project && \
  echo "scalaVersion := \"${SCALA_VERSION}\"" > build.sbt && \
  echo "sbt.version=${SBT_VERSION}" > project/build.properties && \
  echo "case object Temp" > Temp.scala && \
  sbt compile && \
  cd .. && rm -rf precompile
