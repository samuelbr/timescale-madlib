#!/bin/bash

set -m

/docker-entrypoint.sh postgres &

sleep 10

/usr/local/madlib/bin/madpack -s madlib -p postgres install

fg %1