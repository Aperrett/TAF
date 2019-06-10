#!/bin/sh -e

if [ $1 = "Security-Audit" ]; then
    bundle audit check --update
else
    taf "$@"
fi
