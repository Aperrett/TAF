#!/usr/bin/env bash
# A script to build and to start the Test Automation Frame (TAF) container.

# Docker build command
echo "Starting to build TAF docker container"
build_record() {
  docker build -t taf ./
}

build_record
#echo -e $(docker build -t taf ./TAF/) 

# Start TAF docker command with Results folder exposed from the container.
echo "Launching the TAF container into a shell"
echo "To execute a test do the following ......."
docker run --rm -it --name taf -v "$(pwd)"/target:/app/Results:cached taf sh

# Exit the script.
exit $?