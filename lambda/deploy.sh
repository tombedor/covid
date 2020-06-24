#!/usr/bin/env bash

set -euxo pipefail

LAMBDA_NAME=$1
echo "deploying $1"
pushd ./
cd $1

rm -f deployable/function.zip
# This installs a bunch of boto stuff which is not necessary
pip install -r requirements.txt --target ./target
cd target
zip -r9 ../deployable/function.zip .
cd $OLDPWD
zip -g deployable/function.zip lambda_function.py
aws lambda update-function-code --function-name $LAMBDA_NAME --zip-file fileb://deployable/function.zip
popd
