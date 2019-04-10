# Rspec Tests

## Prerequisites

1. Install rspec using `rubygems` with `gem install rspec`.
2. Install docker and docker-compose.

## End-to-End Tests

You will need to first build the correct version of taf to test:

`docker build -f Dockerfile.build -t taf:external-latest --target external .`

Then run `rspec spec/end_to_end`.
