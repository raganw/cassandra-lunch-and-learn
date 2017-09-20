#!/usr/bin/env bash

set -xe

ip=$(ifconfig | grep 172.19.12 | awk '{ print $2 }')
seed="${ip}"

while getopts ":s:" opt; do
  case $opt in
    s)
      seed="${OPTARG}"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

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

sed -i ".bak" \
  -e "s/^listen_address:.*/listen_address: ${ip}/" \
  -e "s/^rpc_address:.*/rpc_address: ${ip}/" \
  -e "s/^\(.*seeds: \).*$/\1${seed}/" \
  cassandra/conf/cassandra.yaml
sed -i ".bak" \
  -e "s/JMX_PORT=.*/JMX_PORT=17199/" \
  cassandra/conf/cassandra-env.sh

echo "Your IP is ${ip}"
