#!/usr/bin/env bash
# A script to build and to start the Test Automation Frame (TAF) container only.

# Docker build command for TAF
echo "Starting to build TAF docker container"
build_record() {
  docker build -t taf .
}

build_record
echo -e $(docker build -t taf .) 

# Start TAF docker command with Results folder exposed from the container.
echo ""
echo "Launching the TAF container into the container shell"
echo "To execute a test type the following code below:"
echo "ruby main.rb Tests/TS_<filename>"
docker run --rm -it --name taf -v "$(pwd)"/target:/app/Results:cached taf sh

# Exit the script.
exit $?