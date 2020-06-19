import datetime
import boto3
import requests.packages.urllib3 as urllib3
import requests
from smart_open import open

import json

bucket = 'party-jams-dot-biz-covid-data'
s3folder = 'nytimes-us-county'
baseURL = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'


def lambda_handler(event, context):
    s3 = boto3.client('s3')
    datetimestamp = datetime.datetime.today().strftime('%Y%m%dT%H%M%S')
    filename = datetimestamp + "_covid_county.csv"
    local_file = "/tmp/" + filename
    key = s3folder + '/' + filename
    http = urllib3.PoolManager()
    response = requests.get(baseURL, stream=True)
    with open(local_file, 'wb') as fout:
        fout.write(response.content)

    s3.upload_file(local_file, bucket, key)

    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('file uploaded' + filename)
    }


if __name__ == '__main__':
    lambda_handler({}, {})
