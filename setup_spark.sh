#!/bin/sh

export SCALA_VERSION=2.12.0
export SCALA_HOME=/opt/scala

export SPARK_VERSION=2.4.5
export SPARK_HOME=/opt/spark
export SPARK_PACKAGE="bin-hadoop2.7"

apk --no-cache add openjdk8

apk add --no-cache --virtual=.build-dependencies wget ca-certificates

apk add --no-cache bash curl jq && \
    cd "/tmp" && \
    wget --no-verbose "https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    mkdir -p "${SCALA_HOME}" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
    rm -rf "/tmp/"*

export PATH="/usr/local/sbt/bin:$PATH" && \
    mkdir -p "/usr/local/sbt" && \
    wget -qO - "https://piccolo.link/sbt-1.3.7.tgz" | tar xz -C /usr/local/sbt --strip-components=1 && \
    sbt sbtVersion

wget -qO "/tmp/spark-${SPARK_VERSION}.tgz" \
    "http://apache.mirrors.tworzy.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-${SPARK_PACKAGE}.tgz"


cd /tmp && \
    tar xzf "/tmp/spark-${SPARK_VERSION}.tgz" && \
    mv "/tmp/spark-${SPARK_VERSION}-${SPARK_PACKAGE}" "${SPARK_HOME}" && \
    rm -rf "/tmp/*"

wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar -P $SPARK_HOME/jars

wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar -P $SPARK_HOME/jars

export PATH=${SCALA_HOME}/bin:${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${PATH}
