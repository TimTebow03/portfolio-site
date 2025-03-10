#!/bin/bash
curl -sSfL https://github.com/getzola/zola/releases/download/v0.20.0/zola-v0.20.0-x86_64-unknown-linux-gnu.tar.gz | tar xz
./zola build
