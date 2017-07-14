FROM anapsix/alpine-java


MAINTAINER Max2 "service@max2.com"

RUN apk add --update unzip wget curl docker jq coreutils

ENV KAFKA_VERSION="0.10.2.1" SCALA_VERSION="2.11"
ADD download-kafka.sh /tmp/download-kafka.sh
RUN mkdir /app && \
    /tmp/download-kafka.sh && \
    tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /app && \
    rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

RUN cd /app && \
    ln -s ./kafka_${SCALA_VERSION}-${KAFKA_VERSION} kafka

ENV KAFKA_HOME /app/kafka
ADD start-kafka.sh /usr/bin/start-kafka.sh
ADD broker-list.sh /usr/bin/broker-list.sh
ADD create-topics.sh /usr/bin/create-topics.sh

VOLUME ["/app/kafka/logs"]

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
ENTRYPOINT ["start-kafka.sh"]
