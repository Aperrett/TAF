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

copy_taf_gem_files(){
  cp -R lib temp/
  cp -R bin temp/
  cp -R taf.gemspec temp/
  cp -R main.rb temp/lib/
  cp -R taf_config.rb temp/lib/
  cp -R report temp/lib/
  cp -R parser temp/lib/
  cp -R utils temp/lib/
  cp -R functions temp/lib/
}

build_taf_gem() {
  releaseflag="$1"
  versionflag="$2"

  if [ -z "$versionflag" ]; then
    echo 'No version flag set.'
    exit 1
  fi

  echo "Building Ruby Gem TAF for: $releaseflag use, with version: $versionflag"

  rm -rf temp && mkdir temp

  copy_taf_gem_files

  case "$releaseflag" in
    internal)
      ;;
    external)
      rm temp/lib/functions/handlers/sso_login.rb
      rm temp/lib/functions/handlers/sint_login.rb
      rm temp/lib/functions/handlers/admin_portal_login.rb
      rm temp/lib/functions/handlers/open_portal_url.rb
      sed -i '' 's/- UKCloud Portal//g' \
        temp/lib/functions/handlers/portal_login.rb \
        temp/lib/functions/handlers/base_handler.rb
      ;;
    *)
      echo 'No valid release flag set.'
      exit 1
      ;;
  esac

  sed -i '' "s/0.0.0/$versionflag/g" temp/lib/version.rb
  sed -i '' "s/releaseflag/$releaseflag/g" temp/taf.gemspec

  cd temp/
  gem build taf.gemspec
  cp "taf-$versionflag.gem" ../
  cd ..
  rm -rf temp

  echo "Built TAF Ruby Gem for: $releaseflag use, with version: $versionflag"
}

delete_results() {
  echo "Deleted all previous test results."
  rm -rf Results
}

delete_taf_image() {
  echo "Checking if TAF Container exists"
  if [ -n "$(docker images -q taf 2>/dev/null)" ]; then
    echo "TAF Container exists"
    docker rmi taf
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

help () {
  check_ruby_version
  echo ""
  echo "usage: taf <command>"
  echo ""
  echo "Build Commands:"
  echo "  build_taf_image                   - Builds Latest TAF Docker Image."
  echo "  build_taf_gem <release> <version> - Builds Latest TAF Ruby Gem."
  echo "                                    - <release> internal use or"
  echo "                                                or external use."
  echo "                                    - <version> e.g. 0.0.1."
  echo ""
  echo "Delete Commands:"
  echo "  delete_results                    - Delete all the previous test results."
  echo "  delete_taf_image                  - Deletes the TAF Docker Image."
  echo ""
  echo "Misc Commands:"
  echo "  help                              - Show this message."
  echo "  lint                              - Run rubocop against taf code."
  echo "  security_audit                    - Run Security Audit of Ruby Gems used for the TAF."
}

main () {
  local command="$1"

  case "$command" in
    build_taf_image)
      build_taf_image
      ;;
    build_taf_gem)
      build_taf_gem "$2" "$3"
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
    *)
      help 1>&2
      exit 1
      ;;
  esac
}

main "$@"
