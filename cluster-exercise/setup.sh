#!/usr/bin/env bash

set -xe

if [ ! -d cassandra ]; then
  CASSANDRA_VERSION="2.2.10"
  if which sha1sum > /dev/null; then
    SHA1SUM=sha1sum
  elif which shasum > /dev/null; then
    SHA1SUM="shasum -a 1"
  fi

  curl -o cassandra.tar.gz -fSL "http://www-us.apache.org/dist/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz" \
    && echo "$(curl -sS http://www-us.apache.org/dist/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz.sha1) *cassandra.tar.gz" | $SHA1SUM -c -

  mkdir cassandra
  tar --strip-components=1 -C cassandra -xzf cassandra.tar.gz 
  rm cassandra.tar.gz
fi

ip=$(ifconfig | grep 172.19.12 | awk '{ print $2 }')

sed -i ".bak" \
  -e "s/^listen_address:.*/listen_address: ${ip}/" \
  -e "s/^rpc_address:.*/rpc_address: ${ip}/" \
  -e "s/^\(.*seeds: \).*$/\1${ip}/" \
  cassandra/conf/cassandra.yaml
sed -i ".bak" \
  -e "s/JMX_PORT=.*/JMX_PORT=17199/" \
  cassandra/conf/cassandra-env.sh

