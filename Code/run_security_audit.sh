set -e

docker build -f Dockerfile .

RUNNER_IMAGE=$(docker build -f Dockerfile -q .)

docker run --rm --volume "$(pwd):/app" "$RUNNER_IMAGE" bundle audit check --update