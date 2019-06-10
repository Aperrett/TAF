#! /usr/bin/env sh
set -e
if [ -n "$DEBUG" ]; then set -x; fi

#
# Main Functions
#

build_taf_image() {
  delete_taf_image
  echo "Building TAF docker image."
  docker build -t taf -f Dockerfile .
}

check_ruby_version() {
  echo "Checking Ruby Version installed:"
  if [[ "$(ruby --version)" == *"ruby 2.5.1"* ]]; then
    echo "Ruby 2.5.1 installed already."
  else
    echo "TAF Requires Ruby 2.5.1. Please install Ruby 2.5.1"
  fi
}

build_taf_gem() {
  releaseflag="$1"
  versionflag=$(ruby -Ilib -r 'taf/version' -e 'puts Taf::VERSION')

  echo "Building Ruby Gem TAF for: $releaseflag use, with version: $versionflag"

  case "$releaseflag" in
    external|internal)
        docker build -f Dockerfile.build -t "taf:$releaseflag-latest" \
          --target "$releaseflag" .
      ;;
    *)
      echo 'No valid release flag set.'
      exit 1
      ;;
  esac

  docker container rm -f taf-build || true
  docker container create --name taf-build "taf:$releaseflag-latest"
  docker container cp taf-build:/taf/taf.gem "taf-$releaseflag-$versionflag.gem"
  docker container rm -f taf-build

  echo "Built TAF Ruby Gem for: $releaseflag use, with version: $versionflag"
}

delete_results() {
  echo "Deleted all previous test results."
  rm -rf Results
}

delete_taf_image() {
  echo "Checking if TAF Container exists"

  image=$(docker images -q taf 2>/dev/null)

  if [ -n "$image" ]; then
    echo "TAF Container exists"
    docker rmi -f "$image"
    echo "Removed TAF Container"
  else
    echo "No TAF container"
  fi
}

lint() {
  echo "Linting taf for errors..."

  if ! command -v rubocop >/dev/null 2>&1; then
    echo "Rubocop is not installed. Run:"
    echo "$ gem install rubocop"
    exit 1
  fi

  rubocop
}

security_audit() {
    echo "Building TAF docker container."./
    docker build -t taf -f Dockerfile .

    RUNNER_IMAGE=$(docker build -t taf -f Dockerfile -q .)
    echo "Running Security Audit of Ruby Gems"
    docker run --rm --volume "$(pwd):/app" "$RUNNER_IMAGE" \
           bundle audit check --update
}

test() {
  # Run end-to-end tests.
  docker-compose -f spec/end_to_end/docker-compose.yml up \
    --build --exit-code-from test
}

help () {
  check_ruby_version
  echo ""
  echo "usage: taf <command>"
  echo ""
  echo "Build Commands:"
  echo "  build_taf_image         - Builds Latest TAF Docker Image."
  echo "  build_taf_gem <release> - Builds Latest TAF Ruby Gem."
  echo "                          - <release> internal use or"
  echo "                                      or external use."
  echo ""
  echo "Delete Commands:"
  echo "  delete_results          - Delete all the previous test results."
  echo "  delete_taf_image        - Deletes the TAF Docker Image."
  echo ""
  echo "Misc Commands:"
  echo "  help                    - Show this message."
  echo "  lint                    - Run rubocop against taf code."
  echo "  test                    - Run tests against taf code."
  echo "  security_audit          - Run Security Audit of Ruby Gems used for the TAF."
}

main () {
  local command="$1"

  case "$command" in
    build_taf_image)
      build_taf_image
      ;;
    build_taf_gem)
      build_taf_gem "$2"
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
    help)
      help
      ;;
    lint)
      lint
      ;;
    test)
      test
      ;;
    *)
      help 1>&2
      exit 1
      ;;
  esac
}

main "$@"
