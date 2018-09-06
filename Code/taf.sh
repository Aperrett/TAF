#! /usr/bin/env bash
set -e
if [ -n "$DEBUG" ]; then set -x; fi

#
# Helper functions
#

resolve_link() {
  $(type -p greadlink readlink | head -1) $1
}

abs_dirname() {
  local path="$1"
  local cwd

  cwd="$(pwd)"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(resolve_link "$name" || true)"
  done

  pwd
  cd "$cwd"
}

#
# Main Functions
#

build_taf_image() {
  echo "Building TAF docker container."
  docker build -t taf -f Dockerfile .
}

delete_results() {
  echo "Deleted all previous test results."
  rm -rf Results
}

delete_taf_image() {
  echo "Checking if TAF Container exists"
  if [ -n "$(sudo docker images -q taf 2>/dev/null)" ]; then
    echo "TAF Container exists"
    docker rmi taf
    echo "Removed TAF Container"
  else
    echo "No TAF container"
  fi
}

build_selenium_grid() {
  echo "Starting Selenium Grid in Docker with the following browsers:"
  echo "Firefox and Chrome"

  docker-compose up -d
  echo -e $(docker-compose up -d)
  echo ""
  echo 'Open a browser to Selenium grid: http://localhost:4444/grid/console'
}

run() {
  echo "Launching the TAF natively in the local shell:"
  echo "Using the following options:" "$1" "$2"
  ruby main.rb "$1" "$2"
}

run_container() {
  echo "Launching the TAF container into the container shell"
  echo "Using the following options:" "$1" "$2"
  docker run --rm -it --name taf -v "$(pwd)"/target:/app/Results:cached taf \
         ruby main.rb "$1" "$2"
}

run_selenium_grid() {
  echo "Launching the TAF container into the container shell"
  echo "Using the following options:" "$1"
  docker run --rm --network taf_selenium_grid_internal --link selenium_hub:hub \
         -it --name taf -v "$(pwd)"/target:/app/Results:cached taf \
         ruby main.rb "$1"
} 

security_audit() {
    echo "Building TAF docker container."
    docker build -t taf -f Dockerfile .

    RUNNER_IMAGE=$(docker build -t taf -f Dockerfile -q .)
    echo "Running Security Audit of Ruby Gems"
    docker run --rm --volume "$(pwd):/app" "$RUNNER_IMAGE" \
           bundle audit check --update
}

help () {
  echo "usage: taf <command>"
  echo ""
  echo "Build Commands:"
  echo "  build_selenium_grid  - Builds Latest Selenium Grid Docker Image."
  echo "  build_taf_image      - Builds Latest TAF Docker Image."
  echo ""
  echo "Delete Commands:"
  echo "  delete_results    - Delete all the previous test results."
  echo "  delete_taf_image  - Deletes the TAF Docker Image."
  echo ""
  echo "Misc Commands:"
  echo "  security_audit  - Run Security Audit of Ruby Gems used for the TAF."
  echo ""
  echo "Run TAF Commands:"
  echo "  run <file> [<browser>]            - Run the TAF natively in shell."
  echo "                                      - <file> TestSuite to run."
  echo "                                      - <browser> overide (optional)."
  echo "  run_container <file> [<browser>]  - Run the TAF in the container"
  echo "                                      shell."
  echo "                                      - <file> TestSuite to run."
  echo "                                      - <browser> overide (optional)."
  echo "  run_selenium_grid <file>          - Run the TAF in the container"
  echo "                                      linked to Selenium Grid."
  echo "                                      - <file> TestSuite to run."
}

main () {
  case "$1" in
    build_selenium_grid)
      build_selenium_grid
      ;;
    build_taf_image)
      build_taf_image
      ;;
    security_audit)
      security_audit
      ;;
    delete_results)
      delete_results
      ;;
    delete_taf_image)
      delete_taf_image
      ;;  
    run)
      run "$2" "$3"
      ;;
    run_container)
      run_container "$2" "$3"
      ;;
    run_selenium_grid)
      run_selenium_grid "$2" "$3"
      ;;
    *)
      help 1>&2
      exit 1
      ;;
  esac
}

main "$@"