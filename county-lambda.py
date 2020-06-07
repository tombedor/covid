import datetime
import os
import boto3
import botocore.vendored.requests.packages.urllib3 as urllib3

bucket = 'party-jams-dot-biz-covid-data'
s3folder = 'nytimes-us-county'
baseURL = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'


def lambda_handler(event, context):
    s3 = boto3.client('s3')
    datetimestamp = datetime.datetime.today().strftime('%Y%m%dT%H%M%S')
    filename = datetimestamp + "_covid_county.csv"
    key = s3folder + '/' + filename
    http = urllib3.PoolManager()
    response = requests.get(baseURL, stream=True)
    with smart_open(s3url, 'wb') as fout:
        fout.write(response.content)
    
    
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('file uploaded' + filename)
    }

