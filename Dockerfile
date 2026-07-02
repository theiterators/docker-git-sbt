FROM docker:25.0.5-git

ENV SBT_VERSION=2.0.1

ENV SCALA_VERSION=3.8.4

ENV JAVA_VERSION_MAJOR=25 \
    JAVA_VERSION_MINOR=0 \
    JAVA_VERSION_BUILD=3_p9-r1

RUN apk update && apk add --no-cache --virtual=build-dependencies tar libcurl curl && \
    curl -sL "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | gunzip | tar -x -C /usr/local && \
    ln -s /usr/local/sbt/bin/sbt /usr/local/bin/sbt && \
    chmod 0755 /usr/local/bin/sbt && \
    rm -f /usr/local/sbt/bin/sbtn-* && \
    echo "--server" >> /usr/local/sbt/conf/sbtopts && \
    apk del build-dependencies

RUN apk add --no-cache bash openjdk${JAVA_VERSION_MAJOR}=${JAVA_VERSION_MAJOR}.${JAVA_VERSION_MINOR}.${JAVA_VERSION_BUILD} --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community

ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION_MAJOR}-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"

RUN \
  mkdir precompile && cd precompile && \
  mkdir -p project && \
  echo "scalaVersion := \"${SCALA_VERSION}\"" > build.sbt && \
  echo "sbt.version=${SBT_VERSION}" > project/build.properties && \
  echo "case object Temp" > project/Temp.scala && \
  echo "case object Temp" > Temp.scala && \
  sbt compile && \
  cd .. && rm -rf precompile