#!/usr/bin/env bash

set -euxo pipefail

LAMBDA_NAME=$1
echo "running $1"
cd $1

aws lambda invoke --function-name $1 --log-type Tail log/output.txt
