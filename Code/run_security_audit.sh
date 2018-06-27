set -e

build_record() {
  docker build -t taf .
}

build_record
echo -e $(docker build -t taf .)

docker run --rm --volume "$(pwd):/app" taf bundle audit check --update