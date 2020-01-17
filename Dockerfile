FROM docker:19.03.3-git

ENV SBT_VERSION 1.3.2

ENV SCALA_VERSION 2.12.9

ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=222 \
    JAVA_VERSION_BUILD=10-r0 

RUN apk update && apk add --no-cache --virtual=build-dependencies tar libcurl curl && \
    curl -sL "https://piccolo.link/sbt-${SBT_VERSION}.tgz" | gunzip | tar -x -C /usr/local && \
    ln -s /usr/local/sbt/bin/sbt /usr/local/bin/sbt && \
    chmod 0755 /usr/local/bin/sbt && \
    apk del build-dependencies

RUN apk add --no-cache bash openjdk${JAVA_VERSION_MAJOR}=${JAVA_VERSION_MAJOR}.${JAVA_VERSION_MINOR}.${JAVA_VERSION_BUILD}

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"

RUN \
  sbt sbtVersion && \
  mkdir precompile && cd precompile && \
  mkdir -p project && \
  echo "scalaVersion := \"${SCALA_VERSION}\"" > build.sbt && \
  echo "sbt.version=${SBT_VERSION}" > project/build.properties && \
  echo "case object Temp" > Temp.scala && \
  sbt compile && \
  cd .. && rm -rf precompile
