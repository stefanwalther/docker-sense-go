#!/usr/bin/env bash

echo "Running the tests";

cd "$PWD/test/fixtures/basic"

docker run --rm -v ${PWD}:/opt/sense-go stefanwalther/sense-go "build -d"
