#!/usr/bin/env bash

set -euxo pipefail

LAMBDA_NAME="nyt-county-data-fetch"

rm -f deployable/function.zip
pip install -r requirements.txt --target ./target
cd target
zip -r9 ../deployable/function.zip .
cd $OLDPWD
zip -g deployable/function.zip lambda_function.py
aws lambda update-function-code --function-name $LAMBDA_NAME --zip-file fileb://deployable/function.zip
