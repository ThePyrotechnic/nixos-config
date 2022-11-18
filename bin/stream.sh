#!/usr/bin/env bash

docker run --rm -it -p 1935:1935 -p 1985:1985 -p 8080:8080 -v ~/Documents/stream/custom.conf:/tmp/custom.conf ossrs/srs:4 \
	./objs/srs -c /tmp/custom.conf

